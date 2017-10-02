class PagesController < ApplicationController

  def bookings
    previous_quarter = Date.today.previous_financial_quarter
    @bookings_last_quarter = Booking.where("comdate > ? AND comdate < ?", previous_quarter.beginning_of_financial_quarter, previous_quarter.end_of_financial_quarter).count
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

end
