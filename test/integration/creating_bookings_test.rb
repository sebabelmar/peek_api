require 'test_helper'

class CreatingBookingsTest < ActionDispatch::IntegrationTest
  test 'creates bookings' do
    timeslot = Timeslot.create(id: 1, start_time: 123456, duration: 120)
    assignment = Assignment.create(id:1, timeslot_id: 1, boat_id: 1)

    post '/api/booking',
    {booking:
      {timeslot_id: 1, size: 6}
      }.to_json, {'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
  end
end