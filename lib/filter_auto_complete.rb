class FilterAutoComplete
  
  
  OPERATORS = %w{= <> < >  bbb like}
  
  def initialize(model_class, the_fields = [])
    @klazz = model_class
    @fields = the_fields.map do |f| f.to_s end
  end
  
  def get_results(orig_value)
    chunks = orig_value.split /(\s*(?:and|or)\s*)/
    if chunks.size > 1
      prefix = chunks[0..-2].join
    else
      prefix = ''
    end
    value = chunks[-1]
      
    #prefix = $1 || ''
    parts = value.split(/\b/, 5)
    parts.pop if parts.size > 1 && parts[-1] == ''  
    result = []
    case 
    when parts.size == 1 #complete field name
      result = @fields.select do |field|
        field.to_s.match value
      end
    when parts.size == 2 #complete operators
      result = OPERATORS
      parts << ''
    when parts.size == 3
      result = OPERATORS.select do |op|
        op.match parts[2]
      end
    when parts.size > 3
      field = parts[0]
      value_prefix = parts[4..-1] || ''
      if (@fields.include? field) && (OPERATORS.include? parts[2] )
        result = @klazz.find(:all, :select => "distinct #{field}", \
          :conditions => ["#{field} LIKE ?", '%' + value_prefix.join() + '%'], \
          :order => "#{field} ASC", :limit => 10 )
        result.map! do |obj|
          " " + obj.send(field).to_s
        end        
      end
    end
    result.map do |postfix|
      parts[-1] = postfix if parts.size > 0
      prefix + parts.join
    end
  end
end
    