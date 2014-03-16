class Address
  include Mongoid::Document
  include Mongoid::Timestamps
end

class Address
  belongs_to :user
end
