class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :omniauthable, :rememberable
  # not :reconfirmable despite evidence to the contrary in the migration
  devise :database_authenticatable, :registerable,
         :confirmable, :lockable, :timeoutable,
         :recoverable, :trackable, :validatable
#  attr_accessor :login

  validates :email, presence: true, confirmation: true, :uniqueness => { :case_sensitive => false  }, :format => { with: /\A[^@]+@[^@\.]+\.[^@]+\z/ }
  validates :username, presence: true, uniqueness:true

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["username = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
  end
end
