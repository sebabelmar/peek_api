require 'date'

class TimeslotsController < ApplicationController
  def index
    timeslots = Timeslot.all

    if date = (params[:date])
      timeslots = timeslots.select_within(date)

      timeslots.map! do |object|
        hash = delete_timestaps(object)
        hash["boats"] = object.boats.map(&:id)
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

  def delete_timestaps(object)
    object.attributes.delete_if{|k, v| k == "created_at" || k == "updated_at"}
  end
end
