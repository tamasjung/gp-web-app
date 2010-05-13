# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def remote_module(module_id)
    %Q(<div class="remote_module" id=#{module_id}> the module id : #{module_id} </div>)
  end
end
