class ResetSupappTable < ActiveRecord::Migration
  def self.up
    Subapp.delete_all
    Subapp.create ([
       {:name => "Lie integrator", :executable => "lieint", :tech_name => "lieint"},
       {:name => "Meep", :executable => "meep", :tech_name => "meep"},
       {:name => "Restricted Three-Body Problem", :executable => "r3bp", :tech_name => "r3bp"},
       {:name => "Schroedinger", :executable => "ndsch", :tech_name => "ndsch"}
      ])
  end

  def self.down
  end

end
