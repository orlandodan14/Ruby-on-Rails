Rails.application.routes.draw do
  
  root 'events#index'
  delete 'logout' => 'sessions#destroy'
  
  resources :events,          only: [:new, :create, :destroy, :show, :index]
  resources :sessions,        only: [:new, :create]
  resources :users,           only: [:new, :create, :show]
  resources :event_attendees, only: [:create, :destroy]
end
