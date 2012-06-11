class User < ActiveRecord::Base
  has_many :articles

  acts_as_authentic do |c|
    # Configuration
  end
end
