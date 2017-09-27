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
      @bookings = bookings_in_time_period(this_year.beginning_of_year, this_year.end_of_year)
    when 'last_year'
      last_year = Date.today.last_year
      @bookings = bookings_in_time_period(last_year.beginning_of_year, last_year.end_of_year)
    else
      raise 'invalid time period argument'
    end

    # bookings_by_agency.json.jbuilder
  end

  def bookings_over_time
    time_unit = params[:time_unit] || 'quarterly'
    bookings = []
    date_cursor = Date.today

    8.times do |i|
      case time_unit
      when 'yearly'
        date_cursor = date_cursor.last_year
        from_date = date_cursor.beginning_of_year
        to_date = date_cursor.end_of_year
        bookings << { period: date_cursor.beginning_of_year.year, booking_count: bookings_in_time_period(from_date, to_date).count }
      when 'quarterly'
        date_cursor = date_cursor.previous_financial_quarter
        from_date = date_cursor.beginning_of_financial_quarter
        to_date = date_cursor.end_of_financial_quarter
        bookings << { period: date_cursor.financial_quarter, booking_count: bookings_in_time_period(from_date, to_date).count }
      when 'monthly'
        date_cursor = date_cursor.last_month
        from_date = date_cursor.beginning_of_month
        to_date = date_cursor.end_of_month
        bookings << { period: date_cursor.beginning_of_month, booking_count: bookings_in_time_period(from_date, to_date).count }
      when 'weekly'
        date_cursor = date_cursor.last_week
        from_date = date_cursor.beginning_of_week
        to_date = date_cursor.end_of_week
        bookings << { period: date_cursor.beginning_of_week, booking_count: bookings_in_time_period(from_date, to_date).count }
      else
        raise 'invalid time period argument'
      end
    end

    render json: bookings
  end

  def adjudication
  end

  def adjudication_by_court
    render json: [
      { agency: 'Court A', value: 2704659 },
      { agency: 'Court TX', value: 2027307 },
      { agency: 'Court NY', value: 1208495 },
      { agency: 'Court FL', value: 1140516 },
      { agency: 'Court IL', value: 894368 },
      { agency: 'Court PA', value: 737462 },
    ]
  end

  def adjudication_by_judge
    render json: [
      { agency: 'Judge CA', value: 2704659 },
      { agency: 'Judge TX', value: 2027307 },
      { agency: 'Judge NY', value: 1208495 },
      { agency: 'Judge FL', value: 1140516 },
      { agency: 'Judge IL', value: 894368 },
      { agency: 'Judge PA', value: 737462 },
    ]
  end

  def population
  end

  def bookings_over_time_params
    params.require(:time_unit)
  end


  private

  def bookings_in_time_period(from_date, to_date)
    Booking.where("comdate > ? AND comdate < ?", from_date, to_date)
  end
end
