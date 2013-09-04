# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repost, parent: :content, class: Repost do
    url { Faker::Internet.url }
    url_name { Faker::Lorem.word }
    repost_permission { [true, false, false].sample }
  end
end
