require 'test_helper'

class CreatingBookingsTest < ActionDispatch::IntegrationTest
  test 'creates bookings' do
    post '/api/booking',
    {booking:
      {timeslot_id: 1, size: 6}
      }.to_json, {'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
  end
end