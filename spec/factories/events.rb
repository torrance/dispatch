# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event, parent: :content, class: Event do
    start { DateTime.now + rand(24).days }
    location { Faker::Lorem.words(1 + rand(2)).split.join(', ') }
  end
end
