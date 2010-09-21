# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
[
  ['Restricted Three-Body Problem','r3bp'],
  ['Lie integrator', 'lieint'],
  ['Schroedinger', 'ndsch'],
  ['Meep', 'meep']
].each do  |rec|
  Subapp.create :name => rec[0], :tech_name => rec[1]
end

