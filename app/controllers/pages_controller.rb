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

  def adjudication
  end

  def population
  end
end
