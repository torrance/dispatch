require 'faker'

FactoryGirl.define do
  factory :article do
    #include ActionDispatch::TestProcess

    title { Faker::Lorem.sentence.gsub(/\.$/, '') }
    summary { Faker::Lorem.sentences(3 + rand(3)).join(' ')[0..300] }
    body { Faker::Lorem.paragraphs(1 + rand(10)).join("\n\n") }
    category { Article::CATEGORIES.sample }
    tag_list { Faker::Lorem.words(1 + rand(5)).split.join(', ') }
    pseudonym { Faker::Name.name }
    status { [1, 1, 1, 2, 2, 3].sample }
    created_at { DateTime.now - rand(730).days }
    images do
      random_images = Dir.new('spec/factories/images').each.to_a.delete_if{ |f| f == '.' || f == '..' }.sample([0, 0, 0, 0, 1, 3, 5].sample)
      random_images.map do |image|
        Image.new(:image => File.open('spec/factories/images/' + image))
      end
    end

    factory :with_existing_user do
      user { User.all.sort_by{ rand }.first }
    end
  end
end
