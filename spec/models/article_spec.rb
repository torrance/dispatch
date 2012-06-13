require 'spec_helper'

describe Article do
  it "has a valid factory" do
    create(:article).should be_valid
  end

  it "rejects an invalid category" do
    build(:article, category: "fake").should_not be_valid
  end

  it "rejects a summary that is too long" do
    build(:article, summary: "i" * 306).should_not be_valid
  end
end
