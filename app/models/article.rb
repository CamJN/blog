class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy

  def title=(new_title)
    if new_title.is_a?(String)
      super new_title.titlecase
    elsif new_title.respond_to?(:to_str)
      super new_title.to_str.titlecase
    end
  end

  validates_associated :comments
  validates :title, presence: true, length: {minimum: 5, maximum: 255}, uniqueness: true
  validates :text, presence: true, length: {minimum: 1}

end
