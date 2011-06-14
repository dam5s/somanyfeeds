# coding: utf-8

class Hash

  # We declare the 6 methods:
  #   self.from_array
  #   self.from_array_with_index
  #   self.from_values
  #   self.from_values_with_index
  #   self.from_keys
  #   self.from_keys_with_index
  #
  # From Array will yield for each element (with index),
  # and expects a key and value in return
  #
  # From Values will yield for each element (with index),
  # and expects a key in return
  #
  # From Keys will yield for each element (with index),
  # and expects a value in return
  #
  class << self
    %w(from_array from_values from_keys).each do |name|
      method =
        case name
        when 'from_array' then <<-METHOD
          array.each do |element|
            key, value = yield(element)
            result[key] = value
          end
        METHOD
        when 'from_values' then <<-METHOD
          array.each {|element| result[yield(element)] = element}
        METHOD
        when 'from_keys' then <<-METHOD
          array.each {|element| result[element] = yield(element)}
        METHOD
        end


      eval <<-EVAL
        def #{name}(array)
          result = new
          #{method}
          result
        end
      EVAL

      method.gsub!('each', 'each_with_index')
      method.gsub!('|element|', '|element, index|')
      method.gsub!('yield(element)', 'yield(element, index)')

      eval <<-EVAL
        def #{name}_with_index(array)
          result = new
          #{method}
          result
        end
      EVAL
    end # each
  end # class << self
end # class
