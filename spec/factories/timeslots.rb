# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timeslot do
    start_time {Time.now.to_i}
    duration {120}
  end
end
