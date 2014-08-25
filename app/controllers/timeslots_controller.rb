class TimeslotsController < ApplicationController
  def index
    timeslots = Timeslot.all
    timeslots.map! do |object|
      hash = object.attributes.delete_if{|k, v| k == "created_at" || k == "updated_at"}
      hash["boats"] = object.boats.to_a
      object = hash
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
end
