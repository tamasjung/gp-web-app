module SerialName
  
  def generate_unique_name(the_base_name = nil, separator = '-')
    name_candidate = the_base_name
    
    has_num_end = name_candidate[/\d*$/]
    if has_num_end && has_num_end.size > 0
      name_candidate = $` + id.to_s
    else
      name_candidate = $` + separator + id.to_s
    end

    name_candidate
    
  end
  
end