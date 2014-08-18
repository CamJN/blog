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

  test "user will not default role to registered when created already having a role" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'aB2!5678'
    newUser.role_id = roles(:adm).id
    newUser.save
    assert_equal roles(:adm).id, newUser.role_id, "user changed role to 'registered' when created with a role"
  end




  test "user valid when password meets all requirements" do
    # test setSize^4 randomly generated valid passwords
    # testing a large subset (5+)^4 of the valid 8 char passwords takes 15+ minutes per run
    # i  |  2 |  3 | 4
    # i^4| 16 | 81 |256
    setSize = 3
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    ('a'..'z').to_a.sample(setSize).each do |lower|
      ('A'..'Z').to_a.sample(setSize).each do |upper|
        ('0'..'9').to_a.sample(setSize).each do |digit|
          [('['..'`'),(':'..'@'),('!'..'/'),('{'..'~')].reduce([]) do | arr, rng | arr.concat(rng.to_a) end.sample(setSize).each do |symbol|
            newUser.password = '    '+lower+upper+digit+symbol
            assert newUser.valid?, "User invalid with valid password '"+newUser.password+"'"
          end
        end
      end
    end
  end

  test "user invalid with too short of a password" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'aB2!567'
    assert_not newUser.valid?, "User valid with too short password"
  end

  test "user invalid with too long of a password" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'aB2!'+'5'*255
    assert_not newUser.valid?, "User valid with too long password"
  end

  test "user invalid with a password lacking a lowercase letter" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'AB2!5678'
    assert_not newUser.valid?, "User valid with a password lacking lowercase letter"
  end

  test "user invalid with a password lacking an uppercase letter" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'ab2!5678'
    assert_not newUser.valid?, "User valid with a password lacking uppercase letter"
  end

  test "user invalid with a password lacking a digit" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'abC!DEFG'
    assert_not newUser.valid?, "User valid with a password lacking a digit"
  end

  test "user invalid with a password lacking a symbol" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'abC3DEFG'
    assert_not newUser.valid?, "User valid with a password lacking a symbol"
  end


  test "user invalid with duplicate username" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.password = 'aB2!5678'
    newUser.username = users(:bob).username
    assert_not newUser.valid?, "User valid with duplicate username"
  end

  test "user invalid without username" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.password = 'aB2!5678'
    assert_not newUser.valid?, "User valid without username"
  end

  test "user invalid with too short of a username" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.password = 'aB2!5678'
    newUser.username = ''
    assert_not newUser.valid?, "User valid with too short of a username"
  end

  test "user invalid with too long of a username" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.password = 'aB2!5678'
    newUser.username = 'u'*260
    assert_not newUser.valid?, "User valid with too long of a username"
  end

  test "user valid with a valid username" do
    newUser = User.new
    newUser.email = 'valid@valid.valid'
    newUser.username = 'unique'
    newUser.password = 'aB2!5678'
    assert newUser.valid?, "User invalid with valid username"
  end




  test "user invalid with duplicate email" do
    newUser = User.new
    newUser.username = 'valid'
    newUser.password = 'aB2!5678'
    newUser.email = users(:bob).email.upcase
    assert_not newUser.valid?, "User valid with duplicate email"
  end

  test "user invalid without email" do
    newUser = User.new
    newUser.username = 'valid'
    newUser.password = 'aB2!5678'
    assert_not newUser.valid?, "User valid without email"
  end

  test "user invalid with too short of an email" do
    newUser = User.new
    newUser.email = 'v@'
    newUser.password = 'aB2!5678'
    newUser.username = ''
    assert_not newUser.valid?, "User valid with too short of an email"
  end

  test "user invalid with too long of an email" do
    newUser = User.new
    newUser.username = 'valid'
    newUser.password = 'aB2!5678'
    newUser.email = 'e@b'+'m'*255
    assert_not newUser.valid?, "User valid with too long of an email"
  end

  test "user valid with a valid email" do
    newUser = User.new
    newUser.email = 'v@v'
    newUser.username = 'unique'
    newUser.password = 'aB2!5678'
    assert newUser.valid?, "User invalid with valid email"
  end

  test "user invalid if email and non nil email confirmation do not match" do
    newUser = User.new
    newUser.email = 'v@v'
    newUser.email_confirmation = 'a@b'
    newUser.username = 'unique'
    newUser.password = 'aB2!5678'
    assert_not newUser.valid?, "User valid with nonmatching email & confirmation"
  end





  test "User can find a user by login = username" do
    assert_not_nil User.find_first_by_auth_conditions({login: users(:bob).username}), "User could not find user by login = username"
  end

  test "User can find correct user by login = username" do
    assert_equal users(:bob).id, User.find_first_by_auth_conditions({login: users(:bob).username}).id, "User could not find correct user by login = username"
  end

  test "User can find a user by login = email" do
    assert_not_nil User.find_first_by_auth_conditions({login: users(:bob).email}), "User could not find user by login = email"
  end

  test "User can find correct user by login = email" do
    assert_equal users(:bob).id, User.find_first_by_auth_conditions({login: users(:bob).email}).id, "User could not find correct user by login = email"
  end

  test "User can find a user by login = email regardless of case" do
    assert_not_nil User.find_first_by_auth_conditions({login: users(:bob).email.upcase}), "User could not find user by login = email with case mismatch"
  end

  test "User can find correct user by login = email regardless of case" do
    assert_equal users(:bob).id, User.find_first_by_auth_conditions({login: users(:bob).email.upcase}).id, "User could not find correct user by login = email with case mismatch"
  end



  test "User can find a user by username" do
    assert_not_nil User.find_first_by_auth_conditions({username: users(:bob).username}), "User could not find user by username"
  end

  test "User can find correct user by username" do
    assert_equal users(:bob).id, User.find_first_by_auth_conditions({username: users(:bob).username}).id, "User could not find correct user by username"
  end

  test "User can find a user by email" do
    assert_not_nil User.find_first_by_auth_conditions({email: users(:bob).email}), "User could not find user by email"
  end

  test "User can find correct user by email" do
    assert_equal users(:bob).id, User.find_first_by_auth_conditions({email: users(:bob).email}).id, "User could not find correct user by email"
  end
end
