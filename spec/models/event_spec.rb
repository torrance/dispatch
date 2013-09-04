require 'spec_helper'

describe Event do
  it "has a valid factory" do
    event = create(:event)
    expect(event).to be_valid
  end
end
