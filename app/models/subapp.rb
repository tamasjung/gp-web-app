class Subapp < ActiveRecord::Base
  has_and_belongs_to_many :application_files
end
