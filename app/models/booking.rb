class Booking < ApplicationRecord
  self.primary_key = 'sysid'

  has_many :charges, class_name: 'CaseCharge', foreign_key: 'sysid'
  has_many :cases, class_name: 'CaseMaster', foreign_key: 'sysid'
  has_many :bonds, class_name: 'BondMaster', foreign_key: 'sysid'
  belongs_to :arrest, foreign_key: 'arrest'

  scope :current, -> { where("reldate < ?", Date.today-100.years) } # when not set, reldate defaults to "1900-01-01 00:00:00"

  def self.between(from_date, to_date)
    Booking.where("comdate > ? AND comdate < ?", from_date, to_date)
  end

  def self.time_series_bookings(time_unit, bookings=Booking.all, percentage_mode:false)
    date_cursor = Date.today
    time_periods = []

    8.times do |i|
      case time_unit
      when 'yearly'
        date_cursor = date_cursor.last_year
        from_date = date_cursor.beginning_of_year
        to_date = date_cursor.end_of_year

        period_name = date_cursor.beginning_of_year.year
        if percentage_mode
          booking_count = bookings.between(from_date, to_date).count / Booking.between(from_date, to_date).count.to_f
        else
          booking_count = bookings.between(from_date, to_date).count
        end
      when 'quarterly'
        date_cursor = date_cursor.previous_financial_quarter
        from_date = date_cursor.beginning_of_financial_quarter
        to_date = date_cursor.end_of_financial_quarter

        period_name = date_cursor.financial_quarter
        if percentage_mode
          booking_count = bookings.between(from_date, to_date).count / Booking.between(from_date, to_date).count.to_f
        else
          booking_count = bookings.between(from_date, to_date).count
        end
      when 'monthly'
        date_cursor = date_cursor.last_month
        from_date = date_cursor.beginning_of_month
        to_date = date_cursor.end_of_month

        period_name = date_cursor.beginning_of_month
        if percentage_mode
          booking_count = bookings.between(from_date, to_date).count / Booking.between(from_date, to_date).count.to_f
        else
          booking_count = bookings.between(from_date, to_date).count
        end
      when 'weekly'
        date_cursor = date_cursor.last_week
        from_date = date_cursor.beginning_of_week
        to_date = date_cursor.end_of_week

        period_name = date_cursor.beginning_of_week
        if percentage_mode
          booking_count = bookings.between(from_date, to_date).count / Booking.between(from_date, to_date).count.to_f
        else
          booking_count = bookings.between(from_date, to_date).count
        end
      else
        raise 'invalid time period argument'
      end

      time_periods << {
        period: period_name,
        booking_count: booking_count,
      }
    end

    time_periods
  end
end
