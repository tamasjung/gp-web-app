require 'active_support'
class FilterParser
  
  
  OPERATORS = %w{= <> < >  like} #<< 'not like'
  
  def initialize(self_assoc, fields, substitutions = {})
    @fields = fields + substitutions.keys
    @fields.map! {|f| f.to_s}
    @subs = substitutions
    @self_assoc = self_assoc.to_s
  end
  
  
  
  def assoc(field_name)
    result = nil
    arr = field_name.split('.')
    if(arr.size == 2)
      result = arr[0].singularize
    end
    result
  end
  
  def parse(str)
    if str.split.size == 1#if there is only on word, it is a 'like'  for the default field, which is the first one
      return {:conditions => ["#{@fields.first} like ?", '%' + str.to_s + '%'], :include => []}
    end
    exps = str.split /(\s+(?:and|or)\s+)/
    result_str = ""
    params = {}
    param_index = 0
    includes = []
    exps.each_with_index do |exp, idx|
      if idx % 2 == 0
        parts = exp.split(/(\s+)/)

        if parts.size >= 5 && @fields.include?(parts[0]) && OPERATORS.include?(parts[2])
          field = parts[0]
          field = @subs[field.to_sym] || field
          assoc_name = assoc field
          includes << assoc_name if assoc_name && assoc_name != @self_assoc
          result_str << field << parts[1..3].join
          param_name = "p#{param_index}".to_sym
          param_index += 1
          result_str << ":#{param_name}"
          value = parts[4..-1].join
          value = "%#{value}%" if parts[2] == 'like'
          params[param_name] = value
        else
          reason = ''
          raise "cannot parse:|#{str}|, parts.size = #{parts.size}, @fields=#{@fields}, parts[0]=#{parts[0]}, parts[2]=#{parts[2]}"
        end
      else
        result_str << exp
      end
    end
    {:conditions => [result_str, params], :include => includes}
  end
  
  
end