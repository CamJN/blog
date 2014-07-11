class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :omniauthable, :rememberable
  # not :reconfirmable despite evidence to the contrary in the migration
  devise :database_authenticatable, :registerable,
         :confirmable, :lockable, :timeoutable,
         :recoverable, :trackable, :validatable
  belongs_to :role
  before_create :set_default_role
  has_many :comments, dependent: :destroy

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  validates :email, presence: true, confirmation: true, :uniqueness => { :case_sensitive => false  },
                    length: {minimum: 3, maximum: 255}, :format => { with: /\A[^@]+@[^@]+\z/ }
  validates :username, presence: true, uniqueness: true, :length => {minimum: 1, maximum: 255}
  validates_format_of :password, allow_nil: true, with: /\A(?=.*[[:lower:]])(?=.*[[:upper:]])(?=.*[[:digit:]])(?=.*[^[:alnum:][:space:]]).*\z/, message: 'must contain an uppercase, lowercase, digit, and symbol'

  def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["username = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
  end

  private
  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end
end
