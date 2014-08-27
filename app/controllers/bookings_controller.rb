class BookingsController < ApplicationController
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def create
    booking = Booking.new(booking_params)

    if booking.save
      use_a_boat(booking.size, booking.timeslot_id)
      update_availability(booking.timeslot_id)
      delete_overlap_assignments(booking.timeslot_id)

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
      if timeslot.boats == 1
        if booking_size <= capacity && booking_size > (capacity / 2) &&
          boat = Boat.find(id)
          boat.use = true
          boat.save
        end
      end
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
    timeslot.customer_count = seats_in_use
    timeslot.save
  end

  def delete_overlap_assignments(id)
      timeslot = Timeslot.find(id)
      assignment_to_check = Assignment.find_by_timeslot_id(id)
      assignment_to_delete = Assignment.find_by_timeslot_id(timeslot.overlap)

      if timeslot.overlap != 0 && assignment_to_delete.boat_id  == assignment_to_check.boat_id
        assignment_to_delete.destroy!
        timeslot_overlap = Timeslot.find(timeslot.overlap)
        timeslot_overlap.availability = 0
        timeslot_overlap.save
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
