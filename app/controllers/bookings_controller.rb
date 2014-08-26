class BookingsController < ApplicationController
  def create
    booking = Booking.new(booking_params)

    if booking.save
      use_a_boat(booking.size, booking.timeslot_id)
      update_availability(booking.timeslot_id)
      render json: booking, status: 201
    end
  end

  private
  def booking_params
    params.require(:booking).permit(:timeslot_id, :size)
  end

  def use_a_boat(booking_size, timeslot_id)
    capacity_available = {}
    boat_id = 0

    timeslot = Timeslot.find(timeslot_id)

    timeslot.boats.each do |boat|
      if boat.use == false
        capacity_available[boat.id] = boat.capacity
      end
    end

    capacity_available.each do |id, capacity|
     if booking_size <= capacity
       boat_id = id
     end
    end

    boat = Boat.find(boat_id)
    boat.use = true
    boat.save
  end

  def update_availability(timeslot_id)
    timeslot = Timeslot.find(timeslot_id)
    total_availability = 0

    timeslot.boats.each do |boat|
      total_availability += boat.capacity if boat.use == false
    end

    seats_in_use = timeslot.bookings.map(&:size).reduce(:+)

    timeslot.availability = total_availability
    timeslot.customer_count = seats_in_use
    timeslot.save
  end
end
