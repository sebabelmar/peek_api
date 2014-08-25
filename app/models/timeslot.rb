class Timeslot < ActiveRecord::Base
  has_many :assigments
  has_many :boats, through: :assigments
end
