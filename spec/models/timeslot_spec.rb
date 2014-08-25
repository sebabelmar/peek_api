require 'spec_helper'

describe Timeslot do
  context 'DB test' do
    let!(:timeslot) { FactoryGirl.create(:timeslot) }
    let!(:boat) { FactoryGirl.create(:boat) }

    it 'has many boats' do
      timeslot.boats << boat
      expect(timeslot.boats).to include boat
    end

    it 'availability and customer count with default values' do
      expect(timeslot.availability).to eq(0)
      expect(timeslot.customer_count).to eq(0)
    end
  end
end
