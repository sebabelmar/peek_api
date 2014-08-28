class TimeslotsController < ApplicationController
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def index
    timeslots = Timeslot.all

    if date = (params[:date])
      timeslots = timeslots.select_within(date)

      timeslots.map! do |object|
        response_hash = Scheduler.delete_timestaps(object)
        response_hash["boats"] = object.boats.map(&:id)
        object = response_hash
      end
    end

    render json: timeslots, status: 200
  end

  def create
    timeslot = Timeslot.new(timeslot_params)

    if timeslot.save
      Scheduler.register_overlaping
      render json: timeslot, status: 201
    end
  end

  private
  def timeslot_params
    params.require(:timeslot).permit(:start_time, :duration, :availability, :customer_count)
  end

  # CORS access control headers
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

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
