# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

500.times{ FactoryGirl.create(:active_user) }

100.times{ FactoryGirl.create(:article_with_existing_user) }

Content.all.each do |content|
  [0, 1, rand(15)].sample.times do
    FactoryGirl.create(:comment_with_existing_user, :content => content)
  end
end
