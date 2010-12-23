class Ability
  include CanCan::Ability
  

  def initialize(user)
    can :create, Person
    
    unless user.nil?
      can [:read, :select], [Launch, Job, ApplicationFile, Subapp]
      can :manage, Person, :id => user.id
      if true || user.has_role?(:researcher) #TODO delete 'true'
        can :manage, [Launch], :person_id => user.id
        can :manage, Job do |job|
          job.launch.person_id = user.id
        end 
      end
      if true || user.has_role?(:senior) #TODO delete 'true' after roles setting
        can :manage, [Subapp], :person_id => user.id
        can :manage, ApplicationFile
        can :manage, [Launch]
        can :appoint_researcher, Person
      end
      if user.has_role? :admin
        can :manage, :all 
        can :appoint_researcher, Person
        can :appoint_senior, Person
        can :appoint_admin, Person
      end
    end
    
  end
end