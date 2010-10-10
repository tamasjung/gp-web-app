class Job < ActiveRecord::Base
  
  STATE_ACTIONS = {
    :CREATED=>[:refresh_state, :stop],
    :SENDING=>[:refresh_state],
    :SENT=>[:refresh_state, :stop],
    :STOPPING=>[:refresh_state],
    :STOPPED=>[:view_result, :restart],
    :FINISHED=>[:view_result, :restart]
  }
  
  enum_field 'state', STATE_ACTIONS.keys.map {|k| k.to_s}
  

    

  
  belongs_to :launch
  
  def address_path
    address ? address.to_s.gsub(/[^\w\.\-]/, '_') : nil
  end
  
  def available_actions
    STATE_ACTIONS[state.to_sym]
  end
end
