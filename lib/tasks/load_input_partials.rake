namespace :db do 
  desc "load input partials into the corresponding sub-app record"
  task :load_input_partials => :environment do 
    Subapp.find(:all).each do |subapp|
      if subapp.tech_name
        file_name = "app/views/input/#{subapp.tech_name}.html.haml"
        if File.exists? file_name
          p "loading " + subapp.name
          subapp.input_partial = File.read file_name
          subapp.save!
          p "...done."
        end
      end
    end
  end
end