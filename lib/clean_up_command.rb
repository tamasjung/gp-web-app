
class CleanUpCommand
  
  include AppLogger
  
  
  dependencies :launch_expiring, :subapp_expiring
  attr_reader :dry_run
  
  def initialize(the_dry_run=true, the_limit = 10)
    @dry_run = the_dry_run
    @limit = the_limit
    logger.info "CleanUpCommand is initialized, launch_expiring = #{launch_expiring}, subapp_expiring = #{subapp_expiring}, limit = #{@limit}, dry_run = #{@dry_run}"
  end
  
  def execute
    logger.info "CleanUpCommand.execute begins"
    clean_launches
    clean_subapps
    logger.info "CleanUpCommand.execute ends"
  end
  
  def clean_launches
    old_launch_num = 0
    expired_launch_num = 0
    offset = 0
    while (old_ones = Launch.all \
      :conditions => ['updated_at < ?', Time.now - launch_expiring], \
      :limit => @limit, :offset => offset).size > 0 do
      logger.debug "offset = #{offset}"
      old_ones.each do |launch|
        old_launch_num += 1
        if launch.expired?
          expired_launch_num += 1
          if @dry_run 
            logger.info "#{launch.id} is expired, it would have been destroyed"
          else
            logger.info "#{launch.id} is expired, it is being destroyed"
            launch.state = Launch::DESTROYING
            launch.save!
            LaunchExecutor.new(launch.id).destroy
            logger.info "#{launch.id} has been destroyed"
          end
        end
      end
      offset += @limit if @dry_run
    end
    logger.info "Number of old launches have found: #{old_launch_num}"
    logger.info "Number of expired launches have processed: #{expired_launch_num}"
  end
  
  def clean_subapps
    old_subapp_num = 0
    expired_subapp_num = 0
    offset = 0
    while (old_ones = Subapp.all \
      :conditions => ['updated_at < ?', Time.now - subapp_expiring], \
      :limit => @limit, :offset => offset).size > 0 do
      old_ones.each do |subapp|
        logger.info "#{subapp.name} is old"
        old_subapp_num += 1
        launch_num = Launch.count :conditions => ['subapp_id = ?', subapp.id]
        if launch_num == 0
          expired_subapp_num =+ 1
          if @dry_run
            logger.info "#{subapp.name} subapp is expired, it would have been destroyed"
          else
            logger.info "#{subapp.name} subapp is being destroyed"
            id = subapp.name
            subapp.destroy
            logger.info "#{id} subapp has been destroyed"
          end
        end
      end
      offset += @limit if @dry_run
    end
    logger.info "Number of old subapps have found: #{old_subapp_num}"
    logger.info "Number of expiredd subapps have processed: #{expired_subapp_num}"
  end
  
  
end 