require 'test_helper'

class ListingTimeslotsTest < ActionDispatch::IntegrationTest

  test 'returns list of all timeslots' do
    timeslot = Timeslot.create(start_time: 1406052000, duration: 120)
    get '/api/timeslots?date=2014-07-22'

    assert_equal 200, response.status
    timeslots = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Array", timeslots.class.to_s
  end


end
