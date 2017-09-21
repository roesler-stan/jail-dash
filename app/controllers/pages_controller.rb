class PagesController < ApplicationController
  def bookings
  end

  def bookings_data
    render json: [
      { agency: 'Agency CA', yrs_lt5: 2704659, yrs_5_13: 4499890 },
      { agency: 'Agency TX', yrs_lt5: 2027307, yrs_5_13: 3277946 },
      { agency: 'Agency NY', yrs_lt5: 1208495, yrs_5_13: 2141490 },
      { agency: 'Agency FL', yrs_lt5: 1140516, yrs_5_13: 1938695 },
      { agency: 'Agency IL', yrs_lt5: 894368, yrs_5_13: 1558919 },
      { agency: 'Agency PA', yrs_lt5: 737462, yrs_5_13: 1345341 },
    ]
  end

  def bookings_data_over_time
    render json: [
      { time: 1, value: 1938695 },
      { time: 2, value: 3277946 },
      { time: 3, value: 2141490 },
      { time: 4, value: 4499890 },
      { time: 5, value: 1558919 },
      { time: 6, value: 1345341 },
    ]
  end

  def adjudication
  end

  def adjudication_data
    render json: [
      { agency: 'Agency CA', value: 2704659 },
      { agency: 'Agency TX', value: 2027307 },
      { agency: 'Agency NY', value: 1208495 },
      { agency: 'Agency FL', value: 1140516 },
      { agency: 'Agency IL', value: 894368 },
      { agency: 'Agency PA', value: 737462 },
    ]
  end

  def population
  end
end
