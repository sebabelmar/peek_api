require 'date'

class TimeslotsController < ApplicationController
  def index
    timeslots = Timeslot.all


    if begging_time = unix_day_min(params[:date])
      timeslots = timeslots.where(start_time: begging_time..unix_day_max(params[:date]))

      timeslots.map! do |object|
        hash = object.attributes.delete_if{|k, v| k == "created_at" || k == "updated_at"}
        hash["boats"] = object.boats.to_a
        object = hash
      end
    end

    render json: timeslots, status: 200
  end

  def create
    timeslot = Timeslot.new(timeslot_params)

    if timeslot.save
      render json: timeslot, status: 201
    end
  end

  private
  def timeslot_params
    params.require(:timeslot).permit(:start_time, :duration, :availability, :customer_count)
  end

  def date_to_unix(date)
    date_arr = date.split('-').map!(&:to_i)
    year, month, day = date_arr[0], date_arr[1], date_arr[2]
    return Date.new(year, month, day).to_time.to_i
  end

  def unix_day_min(date)
    date_to_unix(date)
  end

  def unix_day_max(date)
    unix_day_min(date) + 86399
  end

  def unix_range?(date, start_time)
    (date_to_unix(date)..unix_day_max(date)).include?(start_time)
  end
end
