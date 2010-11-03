class ApplicationFile < ActiveRecord::Base
  
  has_and_belongs_to_many :subapps
  
  def uploaded=(file_field) 
    self.name = base_part_of(file_field.original_filename)
    #self.content_type = file_field.content_type.chomp
    self.bytes = file_field.read
  end
  
  def base_part_of(file_name) 
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end
end
