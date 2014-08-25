require 'spec_helper'

describe Assigment do
  context 'DB test' do
    let!(:timeslot) { FactoryGirl.create(:timeslot) }
    let!(:boat) { FactoryGirl.create(:boat) }

    it 'many to many association' do
      timeslot.boats << boat
      boat.timeslots << timeslot
      expect(Assigment.first).to be_valid
    end
  end
end