class PersonAuth < ActiveRecord::Migration
  def self.up
    change_table(:people) do |t|
      t.string    :login,               :null => false                # optional, you can use email instead, or both
      t.string    :email,               :null => false                # optional, you can use login instead, or both
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
    end
  end

  def self.down
    change_table(:people) do |t|
      t.remove    :login               
      t.remove    :email
      t.remove    :crypted_password
      t.remove    :password_salt
      t.remove    :persistence_token
      t.remove    :single_access_token
      t.remove    :perishable_token
    end
  end
end
