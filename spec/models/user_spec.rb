require 'spec_helper'

describe User do
  it "has a valid factory" do
    create(:user).should be_valid
  end

  it "rejects an empty email" do
    build(:user, email: "").should_not be_valid
  end

  it "rejects an empty password" do
    build(:user, password: "", password_confirmation: "").should_not be_valid
  end

  it "finds by email case insensitively" do
    build(:user, email: "user@domain.com").save
    User.find_by_email("uSeR@DomAin.CoM").should_not be_nil
  end

  it "saves email addresses set to lowercase" do
    user = build(:user, email: "uSeR@DOMaiN.cOm")
    user.email.should == "user@domain.com"
  end
end
