PeekApi::Application.routes.draw do


  get 'api/timeslots', :to => 'timeslots#index'
  post 'api/timeslots', :to => 'timeslots#create'

  get 'api/boats', :to => 'boats#index'
  post 'api/boats', :to => 'boats#create'

  post 'api/assignments', :to => 'assignments#create'


end
