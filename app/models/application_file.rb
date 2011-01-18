class ApplicationFile < ActiveRecord::Base
  
  
  has_and_belongs_to_many :subapps
  
  validates_presence_of :name
  
  def uploaded=(file_field) 
    self.name = base_part_of(file_field.original_filename)
    #self.content_type = file_field.content_type.chomp
    self.bytes = file_field.read
  end
  
  def base_part_of(file_name) 
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end
  
  def unique_name_in_subapp
    
    errors.add_to_base("Must be friends to leave a comment")
  end
end
