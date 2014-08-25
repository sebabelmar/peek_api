require 'test_helper'

class ListingTimeslotsTest < ActionDispatch::IntegrationTest

  test 'returns list of all boats' do
    get '/api/boats'

    assert_equal 200, response.status
    timeslots = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Array", timeslots.class.to_s
  end

end

