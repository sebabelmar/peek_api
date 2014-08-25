require 'spec_helper'

describe Boat do
  context 'DB test' do
    let!(:boat) { FactoryGirl.create(:boat) }
    let!(:timeslot) { FactoryGirl.create(:timeslot) }

    it 'has many timeslots' do
      boat.timeslots << timeslot
      expect(boat.timeslots).to include timeslot
    end
  end
end
