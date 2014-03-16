class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :comment, :type => String
  field :votes, :type => Integer, :default => 0

  def friend
    User.find_by(name: 'friend')
  end
end

class Comment
  has_merit

  belongs_to :user

  if show_attr_accessible?
    attr_accessible :name, :comment, :user_id, :votes
  end

  validates :name, :comment, :user_id, :presence => true

  delegate :comments, :to => :user, :prefix => true
end
