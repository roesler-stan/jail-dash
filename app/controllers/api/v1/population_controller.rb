class Api::V1::PopulationController < ApplicationController

  def condition_of_probation
    time_intervals = 'Yearly'

    bookings = Booking.time_series_bookings(
      time_intervals,
      bookings: Booking.joins(:cases)
        .joins('INNER JOIN billing_communities ON billing_communities.id_guid = case_masters.billing_community')
        .where(billing_communities: { extdesc: 'State Probationary Sentence Inmates' }),
      percentage_mode: true
    )

    render json: bookings
  end

  def justice_court_commitments
    time_intervals = 'Quarterly'

    # queries below are very expensive
    # limit to about last 8 quarters of data for performance
    time_start = Date.today-3.years

    justice_court_booking_ids = ActiveRecord::Base.connection.exec_query(
      <<-SQL
        WITH non_justice_bookings AS (
          SELECT
            bookings.*
          FROM bookings
          INNER JOIN case_masters ON case_masters.sysid = bookings.sysid
          INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code
          WHERE hearing_court_names.slc_id = case_masters.jurisdiction_code
            AND hearing_court_names.extdesc NOT LIKE '%JUSTICE COURT'
        )
        SELECT
          DISTINCT(bookings.sysid) AS booking_id
        FROM bookings
        LEFT OUTER JOIN non_justice_bookings ON non_justice_bookings.sysid = bookings.sysid
        WHERE non_justice_bookings.sysid IS NULL
          AND bookings.comdate > '#{time_start}'
      SQL
    ).map{ |row| row['booking_id'] }

    bookings = Booking.time_series_bookings(
      time_intervals,
      bookings: Booking.where(sysid: justice_court_booking_ids), # we need an AR Relation, so raw SQL above can't go here
      percentage_mode: true
    )

    render json: bookings
  end

  def held_on_fines
    time_intervals = 'Yearly'

    bookings = Booking.time_series_bookings(
      time_intervals,
      bookings: Booking.joins(:bonds).where("bond_masters.bondtype = 'FIN' AND bond_masters.original_bond_amt < 500"),
      percentage_mode: true,
    )

    render json: bookings
  end

end
