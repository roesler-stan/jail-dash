# frozen_string_literal: true

class Api::V1::BookingsController < ApplicationController
  def by_agency
    time_start = params[:time_start] || Date.today.previous_financial_quarter.beginning_of_quarter
    time_end = params[:time_end] || Date.today.previous_financial_quarter.end_of_quarter

    sanitized_time_start = Date.parse(time_start).strftime('%Y-%m-%d')
    sanitized_time_end = Date.parse(time_end).strftime('%Y-%m-%d')

    # TODO: query for demo purposes only - replace with real one for release
    @agencies = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        SELECT TOP 10
          arrests.slc_id,
          arrests.extdesc,
          COUNT(bookings.sysid) AS "booking_count"
        FROM arrests
        INNER JOIN bookings on bookings.arrest = arrests.slc_id
        WHERE bookings.comdate > '#{sanitized_time_start}'
          AND bookings.comdate < '#{sanitized_time_end}'
        GROUP BY arrests.slc_id, arrests.extdesc
        ORDER BY COUNT(bookings.sysid) DESC;
      SQL
    )

    @bookings = Booking.between(time_start, time_end)

    # by_agency.json.jbuilder
  end

  def over_time
    # time params used only when time_intervals == 'custom'
    time_intervals = bookings_over_time_params[:time_intervals] || 'Quarterly'
    time_start = bookings_over_time_params[:time_start]
    time_end = bookings_over_time_params[:time_end]

    bookings = Booking.time_series_bookings(
      time_intervals,
      bookings: Booking.all,
      time_start: time_start,
      time_end: time_end
    )

    render json: bookings
  end

  def over_time_by_agency
    # time params used only when time_intervals == 'custom'
    time_intervals = params[:time_intervals] || 'Yearly'
    time_start = params[:time_start]
    time_end = params[:time_end]

    agencies = Arrest.first(5).map do |agency|
      {
        name: agency.extdesc,
        bookings: Booking.time_series_bookings(
          time_intervals,
          bookings: Booking.where(arrest: agency.slc_id),
          time_start: time_start,
          time_end: time_end
        )
      }
    end

    render json: agencies
  end

  private

  def bookings_over_time_params
    params.permit(:time_intervals, :time_start, :time_end)
  end
end
