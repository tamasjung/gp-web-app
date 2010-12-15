require 'ostruct'

class SettingsAdapter
  
  def initialize(str)
    @settings_hash = HashAccessor.new(ActiveSupport::JSON.decode(str || "{}"))
  end
  
  def sequences
    return [] unless (@settings_hash.respond_to? :launch_params) && @settings_hash.launch_params
    sequences = @settings_hash.launch_params['sequences']
    return [] unless sequences
    sequences.map do |seq_hash|
      Sequence.new(seq_hash)
    end
  end
  
  def files
    return [] unless @settings_hash.respond_to? :launch_params
    files = @settings_hash.launch_params['files']
    return [] unless files
    files.map do |file_hash|
      HashAccessor.new(file_hash)
    end
  end
  
  def references
    return [] unless @settings_hash.respond_to? :launch_params
    references = @settings_hash.launch_params['references']
    return [] unless references
    references.map do |ref_hash|
      HashAccessor.new(ref_hash)
    end
  end
  
  def command_args
    return "" unless @settings_hash.respond_to? :launch_params
    @settings_hash.launch_params['command_args']
  end
  
end

class Launch < ActiveRecord::Base
  
  include SerialName
  
  dependencies :sync_or_async
  
  validates_uniqueness_of :name, :allow_nil => true
  
  belongs_to :subapp
  
  belongs_to :person
  
  belongs_to :parent, :class_name => "Launch", :foreign_key => 'parent_id'
  
  has_many :children, :class_name => "Launch", :foreign_key => "parent_id"
  
  has_many :jobs, :dependent => :destroy
  
  has_and_belongs_to_many :input_files #TBD do we need this?
  
  cattr_reader :per_page
  @@per_page = 10
  
  STATE_ACTIONS = {
    :NEW=>[:save, :start, :cancel],
    :CREATED=>[:save, :start, :destroy],#not used yet
    :QUEUED => [:refresh_state, :stop],
    :SENDING=>[:refresh_state],
    :SENT=>[:refresh_state, :restart, :stop],
    :STOPPING=>[:refresh_state],
    :STOPPED=>[:restart, :destroy, :refresh_state],
    :FINISHED=>[:restart, :destroy, :refresh_state],
    :FAILED=>[:restart, :destroy, :refresh_state],
    :RESTARTING => [:refresh_state],
    :DESTROYING=>[],
    :INVALID => [:destroy]
  }
    
  enum_field 'state', STATE_ACTIONS.keys.map {|k| k.to_s}
  
  def initialize(*args)
    super(*args)
    self.state = NEW
    calculate
  end
  
  def the_only_job
    raise "this is not single a single launch: #{id}" unless single
    raise "too many jobs, launch.id = #{id}, jobs: #{jobs.count}" if jobs.count > 1
    jobs.first
  end
  
  def editable?
    self.state == NEW || self.state == CREATED 
  end
  
  def stable?
    [STOPPED, FINISHED, FAILED, INVALID].include? self.state
  end
  
  def available_actions
    STATE_ACTIONS[state.to_sym]
  end
  
  #model actions
  def action_call(action)
    if available_actions.include? action.to_sym
      logger.debug "Launch.action_call #{action}"
      self.send("do_" + action.to_s)
    else
      logger.debug "action_call: invalid action called: #{action}"
    end
  end
  
  def do_start
    result = false
    Launch.transaction do
      self.state = QUEUED
      result = save
      send_event :start if result
    end
    result
  end
  
  def do_restart
    Launch.transaction do
      self.state = RESTARTING
      save!
      send_event :restart
    end
  end
  
  def do_refresh_state
    send_event :refresh_state unless refreshing
  end
  
  def do_stop
    self.state = STOPPING
    save!
    send_event :stop
  end
  
  def do_destroy
    self.state = DESTROYING
    save!
    send_event :destroy
  end
  
  def do_save
    save
  end
  
  def send_event(method)
    LaunchExecutor.new(id).send sync_or_async, method
  end
  #eo model actions
  
  def check_state
    result = jobs.count :group => :state
    case result.keys.size
    when 0
      case state
      when SENT, STOPPING, STOPPED, FINISHED
        logger.debug {"do_check_state: invalid launch state, id = #{id}, state=#{state}"}
        self.state = INVALID
      end
    when 1
      jobs_state = result.first[0]
      case state
      when SENT, RESTARTING
        self.state = jobs_state if jobs_state == Job::FINISHED || jobs_state == Job::FAILED
      when STOPPING
        self.state = jobs_state if jobs_state == Job::STOPPED
      end
    when 2
      #TODO handle mixed stable states as FINISHED and FAILED together
      if ['FAILED', 'FINISHED'].sort == result.keys.sort
        self.state = FAILED
      end
    end
    save!
    result
  end 
  
  def update_attributes(attrs)
    super
    calculate
  end
  
  def calculate
     @settings_adapter = nil
     self.single = (settings_adapter.sequences.size == 0)
  end
    
  def settings_adapter
    @settings_apapter ||= SettingsAdapter.new(settings)
    @settings_apapter
  end
  
  def generated_name
    result = nil
    if parent
      result = generate_unique_name parent.name
    else
      result = generate_unique_name(subapp.name + "-1")
    end
    result
  end
  
  def all_files_info
    subapp_files = subapp.application_files.find :all, :select => "name, is_executable"
    settings_files = settings_adapter.files.map do |sfile|
      ApplicationFile.new :name => sfile.name, :is_executable => false
    end
    #TODO input_files??
    result = subapp_files + settings_files
    result
  end
  
  #callbacks
  def before_destroy
    #parent rewrite for children
    Launch.update_all(['parent_id = ?', parent.id], ["parent_id = ?", self.id]) if parent
  end
  
end
