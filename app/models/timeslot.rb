class Timeslot < ActiveRecord::Base
  has_many :assignments
  has_many :bookings
  has_many :boats, through: :assignments

  def self.select_within(date)
    self.where(start_time: unix_day_min(date)..unix_day_max(date))
  end

  private
  def self.date_to_unix(date)
    date_arr = date.split('-').map!(&:to_i)
    year, month, day = date_arr[0], date_arr[1], date_arr[2]
    return Date.new(year, month, day).to_time.to_i
  end

  def self.unix_day_min(date)
    date_to_unix(date)
  end

  def self.unix_day_max(date)
    unix_day_min(date) + 86399
  end
end
