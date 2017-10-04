class Api::V1::PopulationController < ApplicationController

  def justice_court_commitments
    time_intervals = 'Yearly'

    bookings = Booking.time_series_bookings(
      time_intervals,
      bookings: Booking.joins(:cases)
        .joins("INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code")
        .where("hearing_court_names.extdesc LIKE '%JUSTICE COURT%'")
        .where("NOT EXISTS(SELECT 1 FROM hearing_court_names WHERE hearing_court_names.slc_id = case_masters.jurisdiction_code AND hearing_court_names.extdesc NOT LIKE '%JUSTICE COURT%')")
        .distinct,
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

  def condition_of_probation
    # billing_communities.extdesc = 'state probationary senctence inmates'
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

end
