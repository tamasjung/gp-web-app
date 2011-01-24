class CleanPeopleAuth < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      %w/
        login 
        crypted_password 
        password_salt 
        persistence_token 
        single_access_token 
        perishable_token/.each do |column|
          t.remove column
        end
    end
  end

  def self.down
  end
end