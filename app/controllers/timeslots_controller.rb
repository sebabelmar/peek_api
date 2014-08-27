require 'date'

class TimeslotsController < ApplicationController
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def index
    timeslots = Timeslot.all

    if date = (params[:date])
      timeslots = timeslots.select_within(date)

      timeslots.map! do |object|
        response_hash = delete_timestaps(object)
        response_hash["boats"] = object.boats.map(&:id)
        object = response_hash
      end
    end

    render json: timeslots, status: 200
  end

  def create
    timeslot = Timeslot.new(timeslot_params)

    if timeslot.save
      register_overlaping
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

  def register_overlaping
    timeslots = Timeslot.all
    timeslots.each do |timeslot|
      init = timeslot.start_time
      timeslots.each do |timeslot_to_compare|
        start_time = timeslot_to_compare.start_time
        finish_time = timeslot_to_compare.start_time + (timeslot_to_compare.duration * 60)

        if (start_time..finish_time).include?(init) && timeslot_to_compare.id != timeslot.id
          timeslot.overlap = timeslot_to_compare.id
          timeslot_to_compare.overlap = timeslot.id
          timeslot.save
          timeslot_to_compare.save
        end
      end
    end
  end

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end
end
