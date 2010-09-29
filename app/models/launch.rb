require 'ostruct'


class Launch < ActiveRecord::Base
  
  dependencies :sync_or_async
  
  belongs_to :subapp
  
  class SettingsAdapter
    
    def initialize(str)
      @settings_hash = OpenStruct.new(ActiveSupport::JSON.decode(str))
    end
    
    def sequences
      result = @settings_hash.launch_params['sequences'].map do |seq_hash| 
        OpenStruct.new(seq_hash)
      end
      result
    end
    
    def files
      
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
  
  def settings_adapter
    SettingsAdapter.new(settings)
  end
  
end
