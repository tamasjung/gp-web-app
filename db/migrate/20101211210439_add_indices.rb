class AddIndices < ActiveRecord::Migration
  
  INDICES = [
    [:application_files, :name],
    [:application_files_subapps, :subapp_id],
    [:application_files_subapps, [:subapp_id, :application_file_id]],
    [:jobs, :launch_id],
    [:jobs, :state],
    [:launches, :name],
    [:launches, :state],
    [:launches, :subapp_id],
    [:launches, :person_id],
    [:launches, :parent_id],
    [:subapps, :name],
    [:subapps, :state],
    [:subapps, :person_id],
    [:subapps, :parent_id]
    ]
  
  def self.up
    INDICES.each do |idx_def|
      add_index *idx_def
    end 
  end

  def self.down
    INDICES.each do |idx_def|
      remove_index *idx_def
    end
  end
end
