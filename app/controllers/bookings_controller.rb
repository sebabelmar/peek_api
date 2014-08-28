class BookingsController < ApplicationController
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def create
    booking = Booking.new(booking_params)

    if booking.save
      Scheduler.use_a_boat(booking.size, booking.timeslot_id)
      Scheduler.delete_overlap_assignments(booking.timeslot_id)
      Scheduler.update_availability_booking(booking.timeslot_id)

      render json: booking, status: 201
    end
  end

  private
  def booking_params
    params.require(:booking).permit(:timeslot_id, :size)
  end

  #CORS access control headers
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
