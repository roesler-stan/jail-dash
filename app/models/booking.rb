class Booking < ApplicationRecord
  self.primary_key = 'sysid'

  has_many :charges, class_name: 'CaseCharge', foreign_key: 'sysid'
  has_many :cases, class_name: 'CaseMaster', foreign_key: 'sysid'
  has_many :bonds, class_name: 'BondMaster', foreign_key: 'sysid'
  belongs_to :arrest, foreign_key: 'arrest'

  scope :current, -> { where("reldate < ?", Date.today-100.years) } # when not set, reldate defaults to "1900-01-01 00:00:00"

  def self.bookings_in_time_period(from_date, to_date)
    Booking.where("comdate > ? AND comdate < ?", from_date, to_date)
  end

  def self.time_series_bookings(time_unit, bookings:Booking.all, time_start:nil, time_end:nil)
    chart_time_steps = 8

    if time_unit == 'custom'
      beginning = Date.parse(time_start)
      ending = Date.parse(time_end)
      date_cursor = ending
      time_step_size = ((ending - beginning).to_i / chart_time_steps)
    else
      date_cursor = Date.today
    end

    time_periods = []

    chart_time_steps.times do |i|
      case time_unit
      when 'yearly'
        date_cursor = date_cursor.last_year
        from_date = date_cursor.beginning_of_year
        to_date = date_cursor.end_of_year
        time_periods << { period: date_cursor.beginning_of_year.year, booking_count: bookings.where("comdate > ? AND comdate < ?", from_date, to_date).count }
      when 'quarterly'
        date_cursor = date_cursor.previous_financial_quarter
        from_date = date_cursor.beginning_of_financial_quarter
        to_date = date_cursor.end_of_financial_quarter
        time_periods << { period: date_cursor.financial_quarter, booking_count: bookings.where("comdate > ? AND comdate < ?", from_date, to_date).count }
      when 'monthly'
        date_cursor = date_cursor.last_month
        from_date = date_cursor.beginning_of_month
        to_date = date_cursor.end_of_month
        time_periods << { period: date_cursor.beginning_of_month, booking_count: bookings.where("comdate > ? AND comdate < ?", from_date, to_date).count }
      when 'weekly'
        date_cursor = date_cursor.last_week
        from_date = date_cursor.beginning_of_week
        to_date = date_cursor.end_of_week
        time_periods << { period: date_cursor.beginning_of_week, booking_count: bookings.where("comdate > ? AND comdate < ?", from_date, to_date).count }
      when 'custom'
        previous_cursor = date_cursor
        date_cursor = date_cursor - time_step_size
        from_date = date_cursor
        to_date = previous_cursor
        time_periods << { period: date_cursor, booking_count: bookings.where("comdate > ? AND comdate < ?", from_date, to_date).count }
      else
        raise 'invalid time period argument'
      end
    end

    time_periods
  end
end
