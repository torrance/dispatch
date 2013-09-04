require 'spec_helper'

describe User do
  fixtures :users

  it "has a valid factory" do
    user = create(:user)
    expect(user).to be_valid
  end

  it "can load drupal user from fixtures" do
    user = User.find(1)
    expect(user.email).to eq 'drupaluser@domain.com'
  end

  it "validates a user with Drupal 6 password encoding (md5)" do
    user = User.find(1)
    expect(user.valid_password?('password')).to be_true
  end

  it "validates a correct password" do
    user = create(:user)
    expect(user.valid_password?('password')).to be_true
  end

  it "rejects an incorrect password" do
    user = create(:user)
    expect(user.valid_password?('incorrect')).to be_false
  end

  it "rejects an empty email" do
    user = build(:user_without_email)
    expect(user).to_not be_valid
  end

  it 'rejects a short password' do
    user = build(:user_with_short_password)
    expect(user).to_not be_valid
  end

  it "rejects an empty password" do
    user = build(:user_without_password)
    expect(user).to_not be_valid
  end

  it "finds by email case insensitively" do
    build(:user, email: "user@domain.com").save
    expect(User.find_by_smart_case_login_field("uSeR@DomAin.CoM")).to_not be_nil
  end
end
