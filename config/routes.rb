Rails.application.routes.draw do
  get '/', to: redirect('/bookings')
  get '/bookings' => 'pages#bookings'
  get '/adjudication' => 'pages#adjudication'
  get '/population' => 'pages#population'

  namespace :api do
    namespace :v1 do
      get '/bookings_by_agency' => 'bookings#by_agency'
      get '/bookings_over_time' => 'bookings#over_time'
      get '/bookings_over_time_by_agency' => 'bookings#over_time_by_agency'
      get '/adjudication_by_court' => 'adjudication#by_court'
      get '/adjudication_by_judge' => 'adjudication#by_judge'
      get '/population_justice_court_commitments' => 'population#justice_court_commitments'
      get '/population_held_on_fines' => 'population#held_on_fines'
      get '/population_condition_of_probation' => 'population#condition_of_probation'
    end
  end
end
