require 'test_helper'

class CreatingAssignmentsTest < ActionDispatch::IntegrationTest
  test 'creates assignments' do
    timeslot = Timeslot.create(id: 1, start_time: 123456, duration: 120)
    booking = Booking.create(id:1, timeslot_id: 1, size: 4)
    boat = Boat.create(id: 1, name: 'Amazon Express', capacity: 8)

    post '/api/assignments',
    {assignment:
      {timeslot_id: 1, boat_id: 1}
      }.to_json, {'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
  end
end