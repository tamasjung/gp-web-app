# Methods added to this helper will be available to all templates in the application.


class Lau
    
  attr_accessor :name, :settings
end
module ApplicationHelper
  def remote_module(module_id)
    %Q(<div class="remote_module" id=#{module_id}> the module id : #{module_id} </div>)
  end
  
  
  def jatek
    lau = Lau.new
    lau.name = "huha"
    lau.settings = "yu"
    lau = {:name => "hhhh", :settings => "rrr "}
    @lau = lau
  end

end
