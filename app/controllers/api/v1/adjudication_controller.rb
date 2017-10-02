class Api::V1::AdjudicationController < ApplicationController

  def by_court
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

  def by_judge
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

end
