PeekApi::Application.routes.draw do


  get 'api/timeslots', :to => 'timeslots#index'
  post 'api/timeslots', :to => 'timeslots#create'



end
