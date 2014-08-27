PeekApi::Application.routes.draw do

  get 'api/timeslots', :to => 'timeslots#index'
  post 'api/timeslots', :to => 'timeslots#create'

  get 'api/boats', :to => 'boats#index'
  post 'api/boats', :to => 'boats#create'

  get 'api/assignments', :to => 'assignments#index'
  post 'api/assignments', :to => 'assignments#create'

  get 'api/bookings', :to => 'bookings#index'
  post 'api/bookings', :to => 'bookings#create'

end
