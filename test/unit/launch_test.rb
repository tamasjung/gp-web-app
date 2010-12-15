require 'test_helper'

class LaunchTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  test "cloning without exception" do
    l = Launch.find 1
    l.clone
  end
  
  test "cloning without exception2" do
    l = Launch.find 2
    l.clone
  end
  
  test "settings launch_params is null" do 
    sa = SettingsAdapter.new '{launch_params: null}'
    sa.sequences
  end
  
  test "destroy" do
    assert_equal Launch.find(3).parent_id, 2
    job = Launch.find(2).jobs[0]
    job_id = job.id
    Launch.destroy 2
    assert_equal Launch.find(3).parent_id, 1
    assert_nil Job.find_by_id(job_id)
  end
  
  test 'cannot destroy' do
    l = Launch.find(2)
    j = l.jobs[0]
    j.state = Job::STOPPING
    j.save
    assert_raise RuntimeError do 
      Launch.destroy(l.id)
    end
  end
  
  test "jobs number" do
    assert_equal Launch.find(2).jobs.size, 2
  end
  
end
