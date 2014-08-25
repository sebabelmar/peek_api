class AssignmentsController < ApplicationController
  def create
    assignment = Assignment.new(assignment_params)

    if assignment.save
      render json: assignment, status: 201
    end
  end

  private
  def assignment_params
    params.require(:assignment).permit(:timeslot_id, :boat_id)
  end

end
