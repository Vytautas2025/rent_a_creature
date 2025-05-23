Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home" # Landing page
  # root to: "creatures#home"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  resources :creatures do
    member do
      get :book               # Form to book a creature
      post :create_booking    # Create a new booking
      get :my_bookings        # View your bookings (as a renter)
      get :manage_bookings    # View bookings for your creatures (as an owner)
      patch :update_booking   # Accept/reject a booking
    end
  end

  # Route to delete a booking
  delete 'bookings/:id', to: 'creatures#cancel_booking', as: :cancel_booking
  get 'my_creatures', to: 'creatures#my_creatures', as: :my_creatures

  get 'creatures_home', to: 'creatures#home', as: :creatures_home
end
