class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Person
    if !user.nil? && user.has_role?(:admin)
      can :manage, :all
    end
    
  end
end