# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  
  def ordering_link(label, name, params, default_dir = 'ASC') 
    name = name.to_s
    ordering = OrderingParams.new params[:orders]
    actual, idx = ordering.get_with_index name
    
    new_dir = nil
    case 
    when actual == default_dir
      new_dir = OrderingParams::opposite default_dir
    when actual == OrderingParams::opposite(default_dir)
      new_dir = nil
    when actual.nil?
      new_dir = default_dir
    end
    ordering.set name, new_dir
    
    new_params = params.clone
    sql  = ordering.to_sql
    if sql.length > 0
      new_params.merge! :orders =>  sql 
    else
      new_params.delete :orders
    end
    link = link_to_remote(label, :url => {:controller => :launches, :action => :select, \
      :params => new_params})

    icon = ""
    case
    when actual == 'ASC'
      icon = '&uarr;'
    when actual == 'DESC'
      icon = '&darr;'
    else
      icon = ''
    end
    
    num = ''
    num = idx + 1 unless idx.nil?
    
    icon = raw "<span class='order_icon order_level_#{[num.to_i, 3].min }'  >#{icon}</span>"

    link + icon
  end
  
end

#from http://www.botvector.net/2008/08/willpaginate-on-ajax.html
class RemoteLinkRenderer < WillPaginate::LinkRenderer  
 def prepare(collection, options, template)    
   @remote = options.delete(:remote) || {}
   super
 end
protected
 def page_link(page, text, attributes = {})
   @template.link_to_remote(text, {:url => url_for(page), :method => :get}.merge(@remote))
   #replace :method => :post if you need POST action
 end
end