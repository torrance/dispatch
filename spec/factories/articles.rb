FactoryGirl.define do
  factory :article, parent: :content, class: Article do


    factory :article_with_existing_user do
      user { User.all.sort_by{ rand }.first }
    end
  end
end
