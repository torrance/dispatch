class Vote < ActiveRecord::Base
  #attr_accessible

  belongs_to :content
  belongs_to :user

  validates :vote, :inclusion => { :in => [-1, 0, 1] }
  validates :user_id, :uniqueness => { :scope => [:content_id] }, :unless => "user_id.nil?"

  after_save :cache_total_in_content

  def self.cast_vote(content_id, user_id, amount)
    vote = Vote.where(:content_id => content_id, :user_id => user_id).first
    if vote.nil?
      vote = Vote.new do |v|
        v.content_id =content_id
        v.user_id = user_id
        v.vote = amount
      end
    else
      vote.vote += amount
    end
    return vote
  end

  def cache_total_in_content
    content = Content.find(content_id)
    content.status = content.total_votes
    content.save
  end
end
