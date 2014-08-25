# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :boat do
    name {'Amazon Express'}
    capacity {8}
  end
end
