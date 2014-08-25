require 'test_helper'

class CreatingBoatsTest < ActionDispatch::IntegrationTest
  test 'creates timeslots' do
    post '/api/boats',
    {boat:
      {name: "Amazona Loca", capacity: 10}
      }.to_json, {'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
  end

end