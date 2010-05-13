class PersonAssocs < ActiveRecord::Migration
  def self.up
    create_table :people_launches, :force => true do |t|
      t.person_id
      t.launch_id
    end
    
    create_table :people_subapps, :force => true do |t|
      t.person_id
      t.subapp_id
    end
  end

  def self.down
    drop_table :people_subapps
    drop_table :people_launches
    
  end
end
