module JobsHelper
  def state_display(job)
    job.state + (job.remote_state ? " (#{job.remote_state.downcase})" : "")
  end
    
end
