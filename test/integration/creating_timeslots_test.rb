require 'test_helper'

class CreatingTimeslotsTest < ActionDispatch::IntegrationTest
  test 'creates timeslots' do
    post '/api/timeslots',
    {timeslot:
      {start_time: 11111111, duration: 120}
      }.to_json, {'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
  end

end