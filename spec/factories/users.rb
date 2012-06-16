require 'faker'

FactoryGirl.define do
  factory :user do
    display_name { Faker::Name.name }
    email { Faker::Internet.email }
    biography { Faker::Lorem.sentences 2 }
    password "password"
  end
end