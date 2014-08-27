class BookingsController < ApplicationController
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def create
    booking = Booking.new(booking_params)

    if booking.save
      use_a_boat(booking.size, booking.timeslot_id)
      delete_overlap_assignments(booking.timeslot_id)
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

    timeslot = Timeslot.find(timeslot_id)

    # refactor this using inject
    timeslot.boats.each do |boat|
      capacity_available[boat.id] = boat.capacity
    end

    puts "**************"
    p capacity_available
    puts "**************"

    puts "**************"
    p timeslot.boats.size
    puts "**************"


    if timeslot.boats.size > 1
      capacity_available.each do |boat_id, capacity|
        puts "**************"
        p boat_id
        p capacity
        puts "**************"

        if booking_size <= capacity && booking_size > (capacity / 2)

          boat = Boat.find(boat_id)
          boat.use = true
          boat.save

          puts "**************"
          p boat.use
          puts "**************"
        end
      end
    end
  end

  def update_availability(timeslot_id)
    timeslot = Timeslot.find(timeslot_id)

    if timeslot.bookings.size > 0
      seats_in_use = timeslot.bookings.map(&:size).reduce(:+)
      timeslot.customer_count = seats_in_use
      timeslot.save
    else
      seats_in_use = 0
    end

    if timeslot.boats.map(&:use).include?(true)
      timeslot.availability =  timeslot.boats.where(use: false).map(&:capacity).reduce(:+)
      timeslot.save
    else
      timeslot.availability = timeslot.boats.map(&:capacity).reduce(:+) - seats_in_use
      timeslot.save
    end
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
