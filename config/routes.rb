Rails.application.routes.draw do
  get '/', to: redirect('/bookings')
  get '/bookings' => 'pages#bookings'
  get '/bookings_by_agency' => 'pages#bookings_by_agency'
  get '/bookings_over_time' => 'pages#bookings_over_time'
  get '/bookings_over_time_by_agency' => 'pages#bookings_over_time_by_agency'
  get '/adjudication' => 'pages#adjudication'
  get '/adjudication_by_court' => 'pages#adjudication_by_court'
  get '/adjudication_by_judge' => 'pages#adjudication_by_judge'
  get '/population' => 'pages#population'
  get '/population_justice_court_commitments' => 'pages#population_justice_court_commitments'
  get '/population_held_on_fines' => 'pages#population_held_on_fines'
  get '/population_condition_of_probation' => 'pages#population_condition_of_probation'
end
