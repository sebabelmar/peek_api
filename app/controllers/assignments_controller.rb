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
      Scheduler.update_boat_use(assignment.timeslot_id, assignment.boat_id)
      Scheduler.update_availability(assignment.timeslot_id)
      render json: assignment, status: 201
    end
  end

  private
  def assignment_params
    params.require(:assignment).permit(:timeslot_id, :boat_id)
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
