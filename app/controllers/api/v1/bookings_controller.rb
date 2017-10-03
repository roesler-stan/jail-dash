class Api::V1::BookingsController < ApplicationController

  def by_agency
    time_unit = params[:time_unit] || 'few_years'

    # TODO: query for demo purposes only - replace with real one for final release
    @agencies = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        SELECT TOP 10
          arrests.slc_id,
          arrests.extdesc,
          COUNT(bookings.sysid) AS "booking_count"
        FROM arrests
        INNER JOIN bookings on bookings.arrest = arrests.slc_id
        WHERE bookings.comdate > '2010-01-01'
        GROUP BY arrests.slc_id, arrests.extdesc
        ORDER BY COUNT(bookings.sysid) DESC;
      SQL
    )

    case time_unit
    when 'this_year'
      this_year = Date.today
      @bookings = Booking.between(this_year.beginning_of_year, this_year.end_of_year)
    when 'last_year'
      last_year = Date.today.last_year
      @bookings = Booking.between(last_year.beginning_of_year, last_year.end_of_year)
    when 'few_years' # TODO: test purposes only - remove this before shipping
      @bookings = Booking.between((Date.today-5.years).beginning_of_year, Date.today.end_of_year)
    else
      raise 'invalid time period argument'
    end

    # bookings_by_agency.json.jbuilder
  end

  def over_time
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(time_unit)

    render json: bookings
  end

  def over_time_by_agency
    time_unit = params[:time_unit] || 'yearly'

    agencies = Arrest.first(5).map do |agency|
      {
        name: agency.extdesc,
        bookings: Booking.time_series_bookings(time_unit, bookings=Booking.where(arrest: agency.slc_id))
      }
    end

    render json: agencies
  end


  private

  def bookings_over_time_params
    params.require(:time_unit)
  end
end
