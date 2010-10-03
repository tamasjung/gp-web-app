require 'ostruct'


class Launch < ActiveRecord::Base
  
  dependencies :sync_or_async
  
  belongs_to :subapp
  
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
    
  enum_field 'state', %w{CREATED SENDING SENT FINISHED STOPPING STOPPED}
  
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
