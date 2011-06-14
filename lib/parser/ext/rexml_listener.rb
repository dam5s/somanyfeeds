#
# Flickr fix
#
# <dc:date.Taken>2010-07-17T18:20:03-08:00</dc:date.Taken>
# "date.Taken" would be target_class which is improper constant name
#
class RSS::REXMLListener
  def known_class?(target_class, class_name)
    class_name and
      if Module.method(:const_defined?).arity == -1
        ( (target_class.const_defined?(class_name, false) rescue false) or
         target_class.constants.include?(class_name.to_sym))
      else
        ( (target_class.const_defined?(class_name) rescue false) or
         target_class.constants.include?(class_name))
      end
  end
end
