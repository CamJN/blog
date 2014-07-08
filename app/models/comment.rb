class Comment < ActiveRecord::Base
  belongs_to :article
  validates :commenter, presence: true, length: {minimum: 2}
  validates :body, presence: true, length: {minimum: 15}, uniqueness: true
end
