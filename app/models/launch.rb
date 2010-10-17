require 'ostruct'

class SettingsAdapter
  
  def initialize(str)
    @settings_hash = HashAccessor.new(ActiveSupport::JSON.decode(str))
  end
  
  def sequences
    sequences = @settings_hash.launch_params['sequences']
    return [] unless sequences
    sequences.map do |seq_hash|
      Sequence.new(seq_hash)
    end
  end
  
  def files
    files = @settings_hash.launch_params['files']
    return [] unless files
    files.map do |file_hash|
      HashAccessor.new(file_hash)
    end
  end
  
  def command_args
    @settings_hash.launch_params['command_args']
  end
  
end

class Launch < ActiveRecord::Base
  
  dependencies :sync_or_async
  
  validates_uniqueness_of :name, :allow_nil => true
  
  belongs_to :subapp
  
  belongs_to :person
  
  belongs_to :parent, :class_name => "Launch", :foreign_key => 'parent_id'
  
  has_many :children, :class_name => "Launch", :foreign_key => "parent_id"
  
  has_many :jobs
  
  has_and_belongs_to_many :input_files
  
  cattr_reader :per_page
  @@per_page = 10
  
  STATE_ACTIONS = {
    :NEW=>[:save, :start, :cancel],
    :CREATED=>[:save, :start, :destroy],#not used yet
    :QUEUED => [:check_state, :refresh_state, :stop],
    :SENDING=>[:check_state, :refresh_state],
    :SENT=>[:check_state, :refresh_state, :stop],
    :STOPPING=>[:check_state, :refresh_state],
    :STOPPED=>[:restart, :destroy],
    :FINISHED=>[:restart, :destroy],
    :DESTROYING=>[],
    :INVALID => [:destroy]
  }
    
  enum_field 'state', STATE_ACTIONS.keys.map {|k| k.to_s}
  
  def initialize(*args)
    super(*args)
    self.state = NEW
    self.single = true
  end
  
  def the_only_job
    raise "this is not single a single launch: #{id}" unless single
    raise "too many jobs" if jobs.count > 1
    jobs.first
  end
  
  def editable?
    self.state == NEW || self.state == CREATED 
  end
  
  def available_actions
    STATE_ACTIONS[state.to_sym]
  end
  
  #model actions
  def action_call(action)
    if available_actions.include? action.to_sym
      logger.debug "Launch.action_call #{action}"
      self.send action
    else
      raise "invalid action: #{action}"
    end
  end
  
  def start
    Launch.transaction do
      self.state = QUEUED
      LaunchExecutor.new(id).send sync_or_async, :start if save
    end
  end
  
  def restart
    LaunchExecutor.new(id).send sync_or_async, :restart
  end
  
  def check_state
    result = jobs.count :group => :state
    case result.keys.size
    when 0
      case state
      when SENT, STOPPING, STOPPED, FINISHED
        self.state = INVALID
      end
    when 1
      jobs_state = result.first[0]
      case state
      when SENT
        self.state = jobs_state if jobs_state == Job::FINISHED
      when STOPPING
        self.state = jobs_state if jobs_state == Job::STOPPED
      end
    end
    save!
    result
  end
  
  def refresh_state
    LaunchExecutor.new(id).send sync_or_async, :refresh_state
  end
  
  def stop
    self.state = STOPPING
    save!
    LaunchExecutor.new(id).send sync_or_async, :stop
  end
  
  def destroy
    self.state = DESTROYING
    save!
    LaunchExecutor.new(id).send sync_or_async, :destroy
  end
  
  
  #eo model actions
  
  def settings=(settings)
    write_attribute :settings, settings
    @settings_adapter = nil
    self.single = (settings_adapter.sequences.size == 0)
    # if(defined?(@settings_adapter))
    #   @settings_adapter = nil
    # end
  end
    
  def settings_adapter
    @settings_apapter ||= SettingsAdapter.new(settings)
    @settings_apapter
  end
  
  def generated_name
    subapp.name + "-" + id.to_s
  end
  
end
