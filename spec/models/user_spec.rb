require 'spec_helper'

describe User do
  it "has a valid factory" do
    create(:user).should be_valid
  end

  it "rejects an empty email" do
    build(:user, email: "").should_not be_valid
  end

  it "rejects an empty password" do
    build(:user, password: "").should_not be_valid
  end

  it "finds by email case insensitively" do
    build(:user, email: "user@domain.com").save
    User.find_by_smart_case_login_field("uSeR@DomAin.CoM").should_not be_nil
  end
end
