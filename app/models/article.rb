class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  validates_associated :comments
  validates :title, presence: true, length: {minimum: 5}, uniqueness: true
  validates :content, presence: true, length: {minimum: 1}
end
