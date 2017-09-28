class PagesController < ApplicationController
  http_basic_authenticate_with name: "jail", password: "dashboard", except: [:bookings_by_agency, :bookings_over_time]
  def bookings
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

  def adjudication
  end

  def adjudication_by_court
    # The years 1900 and 1901 are used to store NULL-like values
    # TODO: Presently showing only those courts with 'DISTRICT COURT' in the name (for performance)
    averages = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        SELECT
          DISTINCT(hearing_court_names.extdesc) AS "name",
          AVG(datediff(dd, bookings.comdate, bookings.reldate)) OVER(PARTITION BY hearing_court_names.slc_id) AS "avg_duration"
        FROM hearing_court_names
        INNER JOIN case_masters ON case_masters.jurisdiction_code = hearing_court_names.slc_id
        INNER JOIN bookings ON bookings.sysid = case_masters.sysid
        WHERE bookings.reldate > '1902-01-01 00:00:00'
          AND hearing_court_names.extdesc LIKE '%DISTRICT COURT%'
        ORDER BY avg_duration DESC;
      SQL
    )

    render json: averages
  end

  def adjudication_by_judge
    # The years 1900 and 1901 are used to store NULL-like values
    # TODO: Presently showing only those judges whose last names start with 'A' (for performance)
    averages = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        SELECT
          DISTINCT(judges.extdesc) AS "name",
          AVG(datediff(dd, bookings.comdate, bookings.reldate)) OVER(PARTITION BY judges.slc_id) AS "avg_duration"
        FROM judges
        INNER JOIN case_masters ON case_masters.judge = judges.slc_id
        INNER JOIN bookings ON bookings.sysid = case_masters.sysid
        WHERE bookings.reldate > '1902-01-01 00:00:00'
        AND judges.extdesc LIKE 'A%'
        ORDER BY avg_duration DESC;
      SQL
    )

    render json: averages
  end

  def population
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
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(time_unit, bookings=Booking.all) # TODO: Write query for "condition of probation"

    render json: bookings
  end

  def bookings_over_time_params
    params.require(:time_unit)
  end

end
