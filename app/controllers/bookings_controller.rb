class BookingsController < ApplicationController
  def create
    booking = Booking.new(booking_params)

    if booking.save
      update_availability(booking.timeslot_id)
      render json: booking, status: 201
    end
  end

  private
  def booking_params
    params.require(:booking).permit(:timeslot_id, :size)
  end

  def update_availability(timeslot_id)
    timeslot = Timeslot.find(timeslot_id)
    timeslot.boats = [boat1, boat2]


    total_availability = timeslot.boats.map(&:capacity).reduce(:+)
    seats_in_use = timeslot.bookings.map(&:size).reduce(:+)

    timeslot.availability = total_availability - seats_in_use
    timeslot.customer_count = seats_in_use
    timeslot.save
  end
end
