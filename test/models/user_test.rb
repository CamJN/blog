require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "user will default login to username when present" do
    assert_equal users(:bob).username, users(:bob).login, "User did not default login to username"
  end

  test "user will default login to email when username not present" do
    emailonly = User.new
    emailonly.email = 'valid@valid.valid'
    assert_equal emailonly.email, emailonly.login, "User did not default to email"
  end

  test "user will remember login if set" do
    bob = users(:bob)
    bob.login = 'hi'
    assert_equal 'hi', bob.login, "User did not retain login"
  end

  test "user will default role to registered when created" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'aB2!5678'
    newUser.save
    assert_equal roles(:reg).id, newUser.role_id, "user did not default role to 'registered' when created"
  end

  test "user will save when password meets all requirements" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'aB2!5678'
    assert newUser.save, "User wouldn't save with valid password"
  end

  test "user will not save with too short of a password" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'aB2!567'
    assert_not newUser.save, "User saved with too short password"
  end

  test "user will not save with too long of a password" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'aB2!567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
    assert_not newUser.save, "User saved with too long password"
  end

  test "user will not save with a password lacking a lowercase letter" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'AB2!5678'
    assert_not newUser.save, "User saved with a password lacking lowercase letter"
  end

  test "user will not save with a password lacking an uppercase letter" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'ab2!5678'
    assert_not newUser.save, "User saved with a password lacking uppercase letter"
  end

  test "user will not save with a password lacking a digit" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'abC!DEFG'
    assert_not newUser.save, "User saved with a password lacking a digit"
  end

  test "user will not save with a password lacking a symbol" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'abC3DEFG'
    assert_not newUser.save, "User saved with a password lacking a symbol"
  end

  test "user will not save without username" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.password = 'aB2!5678'
    assert_not newUser.save, "User saved without username password"
  end

  test "user will not save with too long username" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.password = 'aB2!5678'
    newUser.username = 'usernameistoolongforthedatabasefieldthatitneedstobesavedintowhenitgetspersistedtothedatabasebyrailsactiverecordframeworkblahblahineedonehundredmorecharactersforthisnametobecometoolongtofitintothedatabasefieldthatitwouldbesavedintoifitwerepersistedtothedatabs=ase'
    assert_not newUser.save, "User saved without username password"
  end

  test "" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = users(:bob).username
    newUser.password = 'aB2!5678'
    assert_not newUser.save, "User saved with invalid password"
  end

end

=begin
  validates :email, presence: true, confirmation: true, :uniqueness => { :case_sensitive => false  },
                    length: {minimum: 3, maximum: 255}, :format => { with: \/\A[^@]+@[^@\.]+\.[^@]+\z\/ }
  validates :username, :length => {minimum: 1, maximum: 255}

  def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["username = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
  end
=end
