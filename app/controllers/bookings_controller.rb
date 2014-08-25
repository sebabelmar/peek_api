class BookingsController < ApplicationController
  def create
    booking = Booking.new(booking_params)

    if booking.save
      render json: booking, status: 201
    end
  end

  private
  def booking_params
    params.require(:booking).permit(:timeslot_id, :size)
  end

end
