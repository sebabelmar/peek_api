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
    total_availability = timeslot.boats.map(&:capacity).reduce(:+)

    if timeslot.bookings.size > 0
      seats_in_use = timeslot.bookings.map(&:size).reduce(:+)
    else
      seats_in_use = 0
    end

    timeslot.availability = total_availability - seats_in_use
    timeslot.save
  end
end
