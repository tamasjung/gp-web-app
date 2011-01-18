class FillNickname < ActiveRecord::Migration
  def self.up
    Person.find_all_by_nickname(nil).each do |person|
      person.nickname = person.login
      person.save
    end
  end

  def self.down
  end
end
