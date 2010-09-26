class LaunchExecutor
  def initialize(launch_id)
    @launch_id = launch_id
  end
  
  def perform
    launch = Launch.find @launch_id
    if(launch.state == Launch::CREATED)
      seqs = launch.sequences
      
    end
    perform2
  end
  
  
  
  def perform2
    person = Person.new :nick => 'new2'
    person.save
  end
  
  def start_launch
    launch = Launch.find @launch_id
    
  end
end