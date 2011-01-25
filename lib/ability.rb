class Ability
  include CanCan::Ability
  

  def initialize(user)
    can :create, Person,
    hack = false
    unless user.nil?
      can [:read, :select], [Launch, Job, ApplicationFile, Subapp]
      can [:read, :select, :update, :read_remote_id], Person, :id => user.id
      if hack || user.has_role?(:researcher) #TODO delete 'true'
        can :manage, [Launch], :person_id => user.id
        can :manage, Job do |job|
          job.launch.person_id = user.id
        end 
      end
      if hack || user.has_role?(:senior) #TODO delete 'true' after roles setting
        can :manage, [Subapp], :person_id => user.id
        can :manage, ApplicationFile
        can :manage, [Launch, Job]
        can :appoint_researcher, Person
      end
      if user.has_role? :admin
        can :manage, :all 
        can :approve, Subapp
        can :appoint_researcher, Person
        can :appoint_senior, Person
        can :appoint_admin, Person
        can :read_remote_id, Person
      end
    end
    
  end
end