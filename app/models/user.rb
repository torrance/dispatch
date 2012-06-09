class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # Configuration
  end
end
