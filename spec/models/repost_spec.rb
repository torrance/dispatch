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

  it "rejects very long url names" do
    repost = build(:repost, url_name: "i" * 600)
    expect(repost).to have(1).errors_on(:url_name)
  end

  it "has an empty body if there's no repost permission" do
    repost = create(:repost, repost_permission: false)
    expect(repost.body).to eq('')
  end

  it "has a body if repost permission is granted" do
    repost = create(:repost, repost_permission: true)
    expect(repost.body).to_not eq('')
  end
end
