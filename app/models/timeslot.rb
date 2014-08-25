class Timeslot < ActiveRecord::Base
  has_many :assignments
  has_many :bookings
  has_many :boats, through: :assignments
end
