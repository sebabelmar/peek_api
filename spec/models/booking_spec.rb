require 'spec_helper'

describe Booking do
  context 'DB test' do
    let!(:timeslot) { FactoryGirl.create(:timeslot) }

    it 'timeslots has many bookings' do
      booking = Booking.create(timeslot_id: timeslot.id, size: 4)
      expect(timeslot.bookings).to include booking
    end
  end
end

