class OrderingParams
  
  def initialize(arg)
    case arg
    when String
      @params = self.class.parse_order arg
    when nil
      @params = []
    else
      raise "invalid type of argument: #{arg}/#{arg.class}"
    end
  end
  
  def to_sql
    result = self.class.serialize_order @params
  end
  
  def delete(name)
    name = name.to_s
    @params.reject! do |order_def| order_def[0] == name end
  end
  
  def reverse(name)
    name = name.to_s
    @params.each do |order_def| 
      if order_def[0] == name
        order_def[1] = opposite order_def[1]
      end
    end
  end
  
  def self.opposite(direction)
    case direction.to_s
    when 'ASC'
      'DESC'
    when 'DESC'
      'ASC'
    else
      raise "invalid order direction: #{direction}"
    end
  end
  
  def get(name)
    result, idx = get_with_index(name)
    result
  end
  
  def get_with_index(name)
    result = [nil, nil]
    name = name.to_s
    @params.each_with_index do |i, idx| 
      if i[0] == name
        result = [i[1], idx]
        break
      end
    end
    result
  end
  
  def set(name, direction)
    raise "invalid direction #{direction}" if !direction.nil? && !%w{ASC DESC}.include?(direction)
    delete name
    @params << [name.to_s, direction] if direction
  end
  
  def self.parse_order(str)
    result = []
    str.split(',').each do |i|
      order_def = i.strip.split(/\s+/)
      raise "invalid order def #{str}" unless order_def.size == 2 && ['ASC', 'DESC'].include?(order_def[1])
      raise "invalid order name #{order_def[0]}" unless order_def[0] =~ /^[\w.]+$/
      result << order_def
    end
    result
  end
  
  def self.serialize_order(order_list)
    order_list.map do |item|
      item.join(' ')
    end.join(', ')
  end
  
end