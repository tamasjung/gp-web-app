class Job < ActiveRecord::Base
  
  enum_field 'state', %w{CREATED SENDING SENT FINISHED STOPPING STOPPED}
  
  belongs_to :launch
  
  def address_path
    address ? address.to_s.gsub(/[^\w\.\-]/, '_') : nil
  end
end
