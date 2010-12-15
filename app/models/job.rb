class Job < ActiveRecord::Base
  
  dependencies :sync_or_async
  
  STATE_ACTIONS = {
    :CREATED=>[],
    :SENDING=>[],
    :SENT=>[:stop],
    :UNSENT=>[:restart],
    :STOPPING=>[],
    :STOPPED=>[:restart],
    :FINISHED=>[:restart],
    :FAILED=>[:restart]
  }
  
  enum_field 'state', STATE_ACTIONS.keys.map {|k| k.to_s}
  
  belongs_to :launch
  
  cattr_reader :per_page
  @@per_page = 10
  
  def address_path
    address ? address.to_s.gsub(/[^\w\.\-]/, '_') : nil
  end
  
  def available_actions
    STATE_ACTIONS[state.to_sym]
  end
  
  def do_stop
    Job.transaction do
      self.state = STOPPING
      send_event :stop
    end
  end

  def do_restart
    launch.state = Launch::RESTARTING
    launch.save!
    send_event :restart
  end
  
  def send_event(method)
    JobExecutor.new(id).send sync_or_async, method
  end
  
  def stable?
    [:STOPPED, :FINISHED, :UNSENT].include? state
  end
  
  #callbacks
  def before_destroy
    raise 'Cannot destroy job with state #{self.state}' if [SENDING, SENT, STOPPING].include? self.state
  end
end
