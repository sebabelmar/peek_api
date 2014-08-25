PeekApi::Application.routes.draw do

  get 'api/timeslots', :to => 'timeslots#index'
  post 'api/timeslots', :to => 'timeslots#create'

  get 'api/boats', :to => 'boats#index'
  post 'api/boats', :to => 'boats#create'

  post 'api/assignment', :to => 'assignments#create'
  post 'api/booking', :to => 'bookings#create'

end
