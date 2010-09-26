class JobExecutor
  
  def initializer(job_id)
    @job_id = job_id
  end
  
  def start_job
    job = Job.find job_id
    if(job.status == :created)
      
    end
  end
end