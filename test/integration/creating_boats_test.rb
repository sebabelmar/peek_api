require 'test_helper'

class CreatingBoatsTest < ActionDispatch::IntegrationTest

  test 'creates boats' do
    post '/api/boats',
    {boat:
      {name: "Amazon Express", capacity: 6}
      }.to_json, {'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 201, response.status
  end

end