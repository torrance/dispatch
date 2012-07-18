require 'faker'

FactoryGirl.define do
  factory :user do
    display_name { Faker::Name.name }
    email { Faker::Internet.email }
    biography { Faker::Lorem.sentences(rand 0..4).join(' ') }
    password "password"

    factory :active_user do
      active true
    end

    factory :user_without_email do
      email ''
    end

    factory :user_without_password do
      password ''
    end

    factory :user_with_short_password do
      password 'short'
    end
  end
end