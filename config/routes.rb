Rails.application.routes.draw do
  get '/bookings' => 'pages#bookings'
  get '/adjudication' => 'pages#adjudication'
  get '/population' => 'pages#population'
end
