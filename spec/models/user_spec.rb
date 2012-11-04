require 'spec_helper'

describe User do
  fixtures :users

  it "has a valid factory" do
    create(:user).should be_valid
  end

  it "can load drupal user from fixtures" do
    user = User.find(1)
    user.email.should == 'drupaluser@domain.com'
  end

  it "validates a user with Drupal 6 password encoding (md5)" do
    user = User.find(1)
    user.valid_password?('password').should be_true
  end

  it "validates a correct password" do
    user = create(:user)
    user.valid_password?('password').should be_true
  end

  it "rejects an incorrect password" do
    user = create(:user)
    user.valid_password?('incorrect').should be_false
  end

  it "rejects an empty email" do
    build(:user_without_email).should_not be_valid
  end

  it 'rejects a short password' do
    build(:user_with_short_password).should_not be_valid
  end

  it "rejects an empty password" do
    build(:user_without_password).should_not be_valid
  end

  it "finds by email case insensitively" do
    build(:user, email: "user@domain.com").save
    User.find_by_smart_case_login_field("uSeR@DomAin.CoM").should_not be_nil
  end
end
