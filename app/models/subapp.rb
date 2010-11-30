class Subapp < ActiveRecord::Base
  
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :application_files
  belongs_to :person
  
  belongs_to :parent, :class_name => "Subapp", :foreign_key => 'subapp_id'
  
  has_many :children, :class_name => "Subapp", :foreign_key => "subapp_id"
  
  STATE_ACTIONS = {
    :CREATED=>[:permit, :destroy],
    :PERMITTED=>[:destroy]
  }
    
  enum_field 'state', STATE_ACTIONS.keys.map {|k| k.to_s}
  
  cattr_reader :per_page
  @@per_page = 10
  
  def initialize(*args)
    super(*args)
    self.state = CREATED
  end
end
