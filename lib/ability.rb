class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Person
    unless user.nil?
      #can :destroy, [Launch], :person_id => user.id
      can :manage, Person, :id => user.id
      can :manage, :all if user.has_role?(:admin)
    end
    
  end
end