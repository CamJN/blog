class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  validates :body, presence: true, length: {minimum: 15}, uniqueness: true
end
