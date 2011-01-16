class Refresher
  
  include AppLogger
  
  def execute
    check_launches
  end
  
  def check_launches
    sent_launches = Launch.find :all, :limit => 100, :conditions => {:state => Launch::SENT}
    senct_launches.each do |launch|
      begin
        launch.do_refresh_state
      rescue Exception => e
        logger.fatal e
      end
    end
  end
end