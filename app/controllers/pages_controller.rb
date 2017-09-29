class PagesController < ApplicationController
  http_basic_authenticate_with name: "jail", password: "dashboard"

  def bookings
    previous_quarter = Date.today.previous_financial_quarter
    @bookings_last_quarter = Booking.where("comdate > ? AND comdate < ?", previous_quarter.beginning_of_financial_quarter, previous_quarter.end_of_financial_quarter).count
  end

  def bookings_by_agency
    time_unit = params[:time_unit] || 'last_year'

    @agencies = Arrest.all

    case time_unit
    when 'this_year'
      this_year = Date.today
      @bookings = Booking.bookings_in_time_period(this_year.beginning_of_year, this_year.end_of_year)
    when 'last_year'
      last_year = Date.today.last_year
      @bookings = Booking.bookings_in_time_period(last_year.beginning_of_year, last_year.end_of_year)
    else
      raise 'invalid time period argument'
    end

    # bookings_by_agency.json.jbuilder
  end

  def bookings_over_time
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(time_unit)

    render json: bookings
  end

  def bookings_over_time_by_agency
    time_unit = params[:time_unit] || 'yearly'

    agencies = Arrest.first(10).map do |agency|
      {
        name: agency.extdesc,
        bookings: Booking.time_series_bookings(time_unit, bookings=Booking.where(arrest: agency.slc_id))
      }
    end

    render json: agencies
  end

  def adjudication
    @adjudication_average = Booking.average("datediff(dd, reldate, comdate)").round
    @adjudication_median = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        SELECT
          DISTINCT(PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY datediff(dd, bookings.comdate, bookings.reldate)) OVER()) AS median
        FROM bookings
        WHERE bookings.reldate > '2000-01-01 00:00:00'
        ORDER BY median DESC;
      SQL
    ).first['median']
  end

  def adjudication_by_court
    # The years 1900 and 1901 are used to store NULL-like values
    # TODO: Presently showing only those courts with 'DISTRICT COURT' in the name (for performance)
    from_date = (Date.today-3.years).beginning_of_year.strftime('%Y%m%d')
    to_date = Date.today.end_of_year.strftime('%Y%m%d')
    averages = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        SELECT
          DISTINCT(hearing_court_names.extdesc) AS "name",
          AVG(datediff(dd, bookings.comdate, bookings.reldate)) OVER(PARTITION BY hearing_court_names.slc_id) AS "avg_duration"
        FROM hearing_court_names
        INNER JOIN case_masters ON case_masters.jurisdiction_code = hearing_court_names.slc_id
        INNER JOIN bookings ON bookings.sysid = case_masters.sysid
        WHERE bookings.reldate > '#{from_date}'
          AND bookings.reldate < '#{to_date}'
          AND bookings.reldate > '1902-01-01 00:00:00'
        ORDER BY avg_duration DESC;
      SQL
    )

    render json: averages
  end

  def adjudication_by_judge
    # The years 1900 and 1901 are used to store NULL-like values
    from_date = (Date.today-3.years).beginning_of_year.strftime('%Y%m%d')
    to_date = Date.today.end_of_year.strftime('%Y%m%d')
    averages = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        SELECT
          DISTINCT(judges.extdesc) AS "name",
          AVG(datediff(dd, bookings.comdate, bookings.reldate)) OVER(PARTITION BY judges.slc_id) AS "avg_duration"
        FROM judges
        INNER JOIN case_masters ON case_masters.judge = judges.slc_id
        INNER JOIN bookings ON bookings.sysid = case_masters.sysid
        WHERE bookings.reldate > '#{from_date}'
          AND bookings.reldate < '#{to_date}'
          AND bookings.reldate > '1902-01-01 00:00:00'
        ORDER BY avg_duration DESC;
      SQL
    )

    render json: averages
  end

  def population
    unreleased_bookings = Booking.where("reldate < '1902-01-01 00:00:00'")

    @total_jail_population = unreleased_bookings.count
    @inhouse_jail_population = unreleased_bookings.joins(:cases)
      .where(jlocat: 'MAIN')
      .distinct
      .count
    @held_on_fines_pop = unreleased_bookings.joins(:bonds)
      .where("bond_masters.bondtype = 'FIN' AND bond_masters.original_bond_amt < 500")
      .count
    @held_on_fines_pct = ((@held_on_fines_pop.to_f / @total_jail_population) * 100).round(0)
    @condition_of_probation_pop = unreleased_bookings.joins(:cases)
        .joins('INNER JOIN billing_communities ON billing_communities.id_guid = case_masters.billing_community')
        .where(billing_communities: { extdesc: 'State Probationary Sentence Inmates' })
        .count
    @condition_of_probation_pct = ((@condition_of_probation_pop.to_f / @total_jail_population) * 100).round(0)
    @justice_court_pop = unreleased_bookings.joins(:cases)
      .joins("INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code")
      .where("hearing_court_names.extdesc LIKE '%JUSTICE COURT%'")
      .where("NOT EXISTS(SELECT 1 FROM hearing_court_names WHERE hearing_court_names.slc_id = case_masters.jurisdiction_code AND hearing_court_names.extdesc NOT LIKE '%JUSTICE COURT%')")
      .distinct
      .count
    @justice_court_pct = ((@justice_court_pop.to_f / @total_jail_population) * 100).round(0)
  end

  def population_justice_court_commitments
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(
      time_unit,
      Booking.joins(:cases)
        .joins("INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code")
        .where("hearing_court_names.extdesc LIKE '%JUSTICE COURT%'")
        .where("NOT EXISTS(SELECT 1 FROM hearing_court_names WHERE hearing_court_names.slc_id = case_masters.jurisdiction_code AND hearing_court_names.extdesc NOT LIKE '%JUSTICE COURT%')")
        .distinct
    )

    render json: bookings
  end

  def population_held_on_fines
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(
      time_unit,
      bookings=Booking.joins(:bonds).where("bond_masters.bondtype = 'FIN' AND bond_masters.original_bond_amt < 500")
    )

    render json: bookings
  end

  def population_condition_of_probation
    # billing_communities.extdesc = 'state probationary senctence inmates'
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(
      time_unit,
      bookings=Booking.joins(:cases)
        .joins('INNER JOIN billing_communities ON billing_communities.id_guid = case_masters.billing_community')
        .where(billing_communities: { extdesc: 'State Probationary Sentence Inmates' })
    )

    render json: bookings
  end

  def bookings_over_time_params
    params.require(:time_unit)
  end

end
