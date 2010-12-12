class AddMoreIndices < ActiveRecord::Migration
  INDICES = [
      [:launches, :created_at],
      [:jobs, :created_at],
      [:subapps, :created_at]
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
