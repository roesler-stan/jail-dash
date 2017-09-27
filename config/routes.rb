Rails.application.routes.draw do
  get '/bookings' => 'pages#bookings'
  get '/bookings_by_agency' => 'pages#bookings_by_agency'
  get '/bookings_over_time' => 'pages#bookings_over_time'
  get '/adjudication' => 'pages#adjudication'
  get '/adjudication_data' => 'pages#adjudication_data'
  get '/population' => 'pages#population'
end
