require 'ostruct'

class Launch < ActiveRecord::Base
  
  belongs_to :subapp
  
  
  class SettingsAdapter
    
    def initialize(str)
      settings_hash = ActiveSupport::JSON.decode(settings)
    end
    
    def sequences
      result = settings_hash.each do |key, value| 
        if key =~ /^sequence_name_(\d+)$/ 
          index = $1
          OpenStruct.new(
            :name => value, 
            :begin => settings_hash['sequence_begin_' + index],
            :end => settings_hash['sequence_end_' + index],
            :step => settings_hash['sequence_step_' + index]
          )
        end
      end
      result
    end
    
    def files
      
    end
    
    def command_line
      
    end
  end
    
  
  enum_field 'state', %w{CREATED SENDING SENT FINISHED STOPPING STOPPED}

  
  
  def save_and_launch
    #TODO one tx
    result = save
    LaunchExecutor.new(id).send_later :perform
    result
  end
  
  def settings_adapter
    new SettingsAdapter(settings)
  end
  

end
