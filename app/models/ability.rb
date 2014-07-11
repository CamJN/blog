class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if !user.role_id?
      user.role = Role.find_by({name: 'guest'})
    end

    case user.role.name
    when 'registered'
      can :read, [Article, Comment]
      can :create, Comment
      can [:destroy, :update], Comment, :user => { :id => user.id}
    when 'banned'
      cannot :manage, :all
    when 'moderator'
      can :read, [Article, Comment]
      can [:create,:destroy, :update], Comment
    when 'admin'
      can :manage, :all
    else
      can :read, [Article, Comment]
    end

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
