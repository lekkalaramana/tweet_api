class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user
      can :manage, Tweet, user_id: user.id
    else
      can :read, :all
    end
  end
end
