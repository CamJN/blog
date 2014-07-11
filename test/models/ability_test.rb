require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  test "user can create comments if logged in and not banned" do
    user = users(:one)
    ability = Ability.new(user)
    assert ability.can?(:create, Comment)
  end

  test "moderator can create comments if logged in and not banned" do
    user = users(:bob)
    ability = Ability.new(user)
    assert ability.can?(:create, Comment)
  end

  test "admin can create comments if logged in and not banned" do
    user = users(:ted)
    ability = Ability.new(user)
    assert ability.can?(:create, Comment)
  end

  test "user cannot create comments if banned" do
    user = users(:bad)
    ability = Ability.new(user)
    assert_not ability.can?(:create, Comment)
  end

end
