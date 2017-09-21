Rails.application.routes.draw do
  get '/bookings' => 'pages#bookings'
  get '/bookings_data' => 'pages#bookings_data'
  get '/adjudication' => 'pages#adjudication'
  get '/adjudication_data' => 'pages#adjudication_data'
  get '/population' => 'pages#population'
end
