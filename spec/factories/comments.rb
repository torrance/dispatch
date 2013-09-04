# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraphs([1, 1, 1 + rand(4)].sample).join("\n\n") }
    content { content }
    created_at { content.created_at - rand(8).days - rand(24).hours }
    status { [1, 1, 1, 1, 1, 1, 1, 0].sample }

    factory :comment_with_existing_user do
      user { User.all.sort_by{ rand }.first }
    end
  end
end