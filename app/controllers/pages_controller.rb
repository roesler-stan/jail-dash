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
    @inhouse_jail_population = unreleased_bookings.where(jlocat: 'MAIN')
      .distinct
      .count

    held_on_fines = unreleased_bookings.joins(:bonds)
      .where("bond_masters.type_id = 'FIN' AND bond_masters.original_bond_amt < 500")
    @held_on_fines_pop = 0
    @held_on_fines_pct = 0
    if held_on_fines
      @held_on_fines_pop = held_on_fines.count
      @held_on_fines_pct = ((@held_on_fines_pop.to_f / @total_jail_population) * 100).round(0)
    end

    condition_of_probation = unreleased_bookings.joins(:cases)
        .joins('INNER JOIN billing_communities ON billing_communities.id_guid = case_masters.billing_community')
        .where(billing_communities: { extdesc: 'State Probationary Sentence Inmates' })
    @condition_of_probation_pop = 0
    @condition_of_probation_pct = 0
    if condition_of_probation
      @condition_of_probation_pop = condition_of_probation.count
      @condition_of_probation_pct = ((@condition_of_probation_pop.to_f / @total_jail_population) * 100).round(0)
    end

    @justice_court_pop = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        WITH non_justice_bookings AS (
          SELECT
            DISTINCT(bookings.sysid)
          FROM bookings
          INNER JOIN case_masters ON case_masters.sysid = bookings.sysid
          INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code
          WHERE hearing_court_names.extdesc NOT LIKE '%JUSTICE COURT'
        )
        SELECT
          COUNT(DISTINCT(bookings.sysid)) AS current_justice_bookings
        FROM bookings
        LEFT OUTER JOIN non_justice_bookings ON non_justice_bookings.sysid = bookings.sysid
        INNER JOIN case_masters ON case_masters.sysid = bookings.sysid
        INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code
        WHERE non_justice_bookings.sysid IS NULL
          AND bookings.reldate < '1902-01-01 00:00:00'
      SQL
    ).first['current_justice_bookings']
    @justice_court_pct = ((@justice_court_pop.to_f / @total_jail_population) * 100).round(0)
    @justice_court_stats_by_court = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        WITH non_justice_bookings AS (
          SELECT bookings.*
          FROM bookings
          INNER JOIN case_masters ON case_masters.sysid = bookings.sysid
          INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code
          WHERE hearing_court_names.extdesc NOT LIKE '%JUSTICE COURT'
        ),
        unreleased_justice_court_bookings AS (
          SELECT bookings.*
          FROM bookings
          LEFT OUTER JOIN non_justice_bookings ON non_justice_bookings.sysid = bookings.sysid
          WHERE non_justice_bookings.sysid IS NULL
            AND bookings.reldate < '1902-01-01 00:00:00'
        ),
        total_bookings AS (
            SELECT
                hearing_court_names.extdesc AS name,
                count(unreleased_justice_court_bookings.sysid) AS bookings_count
            FROM unreleased_justice_court_bookings
            INNER JOIN case_masters ON case_masters.sysid = unreleased_justice_court_bookings.sysid
            INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code
            GROUP BY hearing_court_names.extdesc
        )
        SELECT
            total_bookings.name as name,
            total_bookings.bookings_count,
            cast(
                total_bookings.bookings_count as float
            ) / (
                SELECT COUNT(*) FROM unreleased_justice_court_bookings)*100 as bookings_pct
        FROM total_bookings
        GROUP BY
            total_bookings.name,
            total_bookings.bookings_count
      SQL
    )
  end

end
