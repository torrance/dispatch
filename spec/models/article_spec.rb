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
end
