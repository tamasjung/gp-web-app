class Person < ActiveRecord::Base
  has_and_belongs_to_many :subapps
  has_and_belongs_to_many :launches
end
