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
  
  belongs_to :subapp
  
  belongs_to :person
  
  belongs_to :parent, :class_name => "Launch", :foreign_key => 'parent_id'
  
  has_many :children, :class_name => "Launch", :foreign_key => "parent_id"
  
  has_many :jobs
  
  has_has_and_belongs_to_many :input_files
  
  cattr_reader :per_page
  @@per_page = 10
  
  STATE_ACTIONS = {
    :CREATED=>[:refresh_state, :start, :stop],#not used yet
    :QUEUED => [:refresh_state, :stop],
    :SENDING=>[:refresh_state],
    :SENT=>[:refresh_state, :stop],
    :STOPPING=>[:refresh_state],
    :STOPPED=>[:view_result, :restart],
    :FINISHED=>[:view_result, :restart]
  }
    
  enum_field 'state', STATE_ACTIONS.keys.map {|k| k.to_s}
  
  def editable?
    state == nil || state == 'CREATED'
  end
  
  def save_and_launch
    #TODO one tx
    result = save
    LaunchExecutor.new(id).send sync_or_async, :perform
    result
  end
  
  def settings=(settings)
    write_attribute :settings, settings
    if(defined?(@settings_adapter))
      @settings_adapter = nil
    end
  end
    
  def settings_adapter
    @settings_apapter ||= SettingsAdapter.new(settings)
    @settings_apapter
  end
  
end
