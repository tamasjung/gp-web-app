module JobsHelper
  def state_display(job)
    job.state + (job.remote_state ? " (#{r_state_display.downcase})" : "")
  end
    
end
