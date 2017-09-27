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
      @bookings = Booking.bookings_in_time_period(this_year.beginning_of_year, this_year.end_of_year)
    when 'last_year'
      last_year = Date.today.last_year
      @bookings = Booking.bookings_in_time_period(last_year.beginning_of_year, last_year.end_of_year)
    else
      raise 'invalid time period argument'
    end

    # bookings_by_agency.json.jbuilder
  end

  def bookings_over_time
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(time_unit)

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

  def population_justice_court_commitments
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(
      time_unit,
      Booking.joins(:cases)
        .joins("INNER JOIN hearing_court_names ON hearing_court_names.slc_id = case_masters.jurisdiction_code")
        .where("hearing_court_names.extdesc LIKE '%JUSTICE COURT%'")
        .where("NOT EXISTS(SELECT 1 FROM hearing_court_names WHERE hearing_court_names.slc_id = case_masters.jurisdiction_code AND hearing_court_names.extdesc NOT LIKE '%JUSTICE COURT%')")
        .distinct
    )

    render json: bookings
  end

  def population_held_on_fines
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(
      time_unit,
      bookings=Booking.joins(:bonds).where("bond_masters.bondtype = 'FIN' AND bond_masters.original_bond_amt < 500")
    )

    render json: bookings
  end

  def population_condition_of_probation
    time_unit = params[:time_unit] || 'quarterly'

    bookings = Booking.time_series_bookings(time_unit, bookings=Booking.all) # TODO: Write query for "condition of probation"

    render json: bookings
  end

  def bookings_over_time_params
    params.require(:time_unit)
  end

end
