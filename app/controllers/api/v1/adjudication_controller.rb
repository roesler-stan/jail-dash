class Api::V1::AdjudicationController < ApplicationController

  def by_court
    time_start = adjudication_params[:time_start]
    time_end = adjudication_params[:time_end]

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
        WHERE bookings.reldate > '#{time_start}'
          AND bookings.reldate < '#{time_end}'
          AND bookings.reldate > '1902-01-01 00:00:00'
        ORDER BY avg_duration DESC;
      SQL
    )

    render json: averages
  end

  def by_judge
    time_start = adjudication_params[:time_start]
    time_end = adjudication_params[:time_end]

    # The years 1900 and 1901 are used to store NULL-like values
    averages = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        SELECT
          DISTINCT(judges.extdesc) AS "name",
          AVG(datediff(dd, bookings.comdate, bookings.reldate)) OVER(PARTITION BY judges.slc_id) AS "avg_duration"
        FROM judges
        INNER JOIN case_masters ON case_masters.judge = judges.slc_id
        INNER JOIN bookings ON bookings.sysid = case_masters.sysid
        WHERE bookings.reldate > '#{time_start}'
          AND bookings.reldate < '#{time_end}'
          AND bookings.reldate > '1902-01-01 00:00:00'
        ORDER BY avg_duration DESC;
      SQL
    )

    render json: averages
  end

  def adjudication_params
    params.permit(:time_start, :time_end)
  end

end
