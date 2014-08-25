require 'test_helper'

class CreatingAssignmentsTest < ActionDispatch::IntegrationTest
  test 'creates assignments' do
    post '/api/assignment',
    {assignment:
      {timeslot_id: 1, boat_id: 1}
      }.to_json, {'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
  end
end