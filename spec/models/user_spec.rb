require 'spec_helper'

describe User do
  let(:user) do
    user = User.new do |u|
      u.display_name = "Firstname Lastname"
      u.email = 'test123@test.com'
      u.password = "password123"
      u.password_confirmation = 'password123'
    end
  end

  it "should be able to be created" do
    user.save.should be_true
  end

  it 'should reject an empty email' do
    user.email = ''
    user.save.should be_false
  end

  it 'should reject an empty password' do
    user.password = ''
    user.password_confirmation = ''
    user.save.should be_false
  end

  it 'should retrieve email addresses set to lowercase' do
    user.save
    user1 = User.find_by_email('tEsT123@GmaIl.COM')
    (user == user1).should be_true
  end

  it 'should save email addresses set to lowercase' do
    user.email = 'TEST123@TeSt.cOm'
    user.save
    user1 = User.find_by_email('test123@gmail.com')
    (user == user1).should be_true
  end
end
