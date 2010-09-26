class Job < ActiveRecord::Base
  
  enum_field 'state', %w{CREATED SENDING SENT FINISHED STOPPING STOPPED}
  
  belongs_to :launch
end
