class AssignmentsController < ApplicationController
  def create
    assignment = Assignment.new(assignment_params)

    if assignment.save
      update_availability(assignment.timeslot_id)

      render json: assignment, status: 201
    end
  end

  private
  def assignment_params
    params.require(:assignment).permit(:timeslot_id, :boat_id)
  end

  def update_availability(timeslot_id)
    timeslot = Timeslot.find(timeslot_id)
    boats = timeslot.boats
    total_availability = boats.map(&:capacity).reduce(:+)
    timeslot.availability = total_availability
  end

end
