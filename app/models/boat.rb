class Boat < ActiveRecord::Base
  has_many :assigments
  has_many :timeslots, through: :assigments
end
