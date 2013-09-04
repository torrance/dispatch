require 'spec_helper'

describe Repost do
  it "has a valid factory" do
    repost = create(:repost)
    expect(repost).to be_valid
  end

  it "rejects invalid urls" do
    repost = build(:repost, url: "not a real url")
    expect(repost).to have(1).errors_on(:url)
  end
end
