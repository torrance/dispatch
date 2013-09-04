require 'spec_helper'

describe Comment do
  it "has a valid factory" do
    comment = create(:comment)
    expect(comment).to be_valid
  end
end
