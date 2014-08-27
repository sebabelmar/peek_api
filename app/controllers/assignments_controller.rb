class AssignmentsController < ApplicationController
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def index
    boats = Assignment.all

    render json: boats, status: 200
  end

  def create
    assignment = Assignment.new(assignment_params)

    if assignment.save
      update_boat_use(assignment.timeslot_id, assignment.boat_id)
      update_availability(assignment.timeslot_id)
      render json: assignment, status: 201
    end
  end

  private
  def assignment_params
    params.require(:assignment).permit(:timeslot_id, :boat_id)
  end

  def update_boat_use(timeslot_id, boat_id)
    timeslot = Timeslot.find(timeslot_id)

    if timeslot.overlap == 0
      boat = Boat.find(boat_id)
      boat.use = false
      boat.save
    end

  end

  def update_availability(timeslot_id)
    timeslot = Timeslot.find(timeslot_id)

    total_availability = 0

    timeslot.boats.each do |boat|
      total_availability += boat.capacity if boat.use == false
    end

    if timeslot.bookings.size > 0
      seats_in_use = timeslot.bookings.map(&:size).reduce(:+)
    else
      seats_in_use = 0
    end

    timeslot.availability = total_availability - seats_in_use
    timeslot.save
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
