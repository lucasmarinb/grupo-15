class User < ApplicationRecord
	validates :name, presence:true, uniqueness: true, allow_blank: false
	validates :password, presence:true, length: { in 6..20 },
						 confirmation: true
	validates :email, presence: true, uniqueness: true, allow_blank: false, 
					  format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i 

	has_many :comments
	has_many :pledges
	has_many :projects

	has_many :follower_relationships, foreign_key: :following_id,
                                    class_name: 'Follow'
  has_many :following_relationships, foreign_key: :follower_id,
                                     class_name: 'Follow'

  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following, through: :following_relationships, source: :following
end
