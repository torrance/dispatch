require 'faker'

FactoryGirl.define do
  factory :article do
    title { Faker::Lorem.words(rand 3..7) }
    summary { Faker::Lorem.sentences(rand 2..4) }
    body { Faker::Lorem.paragraphs(rand 2..8) }
    category { Article::CATEGORIES.sample }
    pseudonym { Faker::Name.name }
  end
end
