require 'spec_helper'

describe Article do
  it "has a valid factory" do
    article = create(:article)
    expect(article).to be_valid
  end

  it "rejects an invalid category" do
    article = build(:article, category: "fake")
    expect(article).to_not be_valid
  end

  it "rejects a summary that is too long" do
    article = build(:article, summary: "i" * 306)
    expect(article).to_not be_valid
  end

  it "knows who authored it" do
    user1 = create(:user)
    user2 = create(:user)
    article = create(:article, user: user1)
    expect(article.author? user1).to be_true
    expect(article.author? user2).to be_false
  end

  it "knows when it is a feature" do
    normal = create(:article, status: 0)
    subfeature = create(:article, status: 1)
    feature = create(:article, status: 2)
    expect(normal.feature?).to be_false
    expect(subfeature.feature?).to be_true
    expect(feature.feature?).to be_true
  end

  it "knows its status name" do
    normal = create(:article, status: 0)
    subfeature = create(:article, status: 1)
    feature = create(:article, status: 2)
    expect(normal.status_name).to eq("Normal")
    expect(subfeature.status_name).to eq("Sub-feature")
    expect(feature.status_name).to eq("Feature")
  end

  it "rejects more than 5 tags" do
    article = build(:article, tag_list: 'one, two, three, four, five, six')
    expect(article).to have(1).errors_on(:tag_list)
  end

  it "knows it is an article" do
    article = create(:article)
    expect(article.article?).to be_true
  end
end
