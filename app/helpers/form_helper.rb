module FormHelper

  def errors(object, attribute)
    object.errors[attribute].join(', ')
  end

  def prefix(object)
    object.class.to_s.underscore.split('/').first
  end

  def field_name(object, attribute)
    "#{prefix object}[#{object.id}][#{attribute}]"
  end

  def class_name(object, attribute)
    "#{prefix object}-#{attribute}"
  end

  def field_options(object, attribute)
    { value: object.send(attribute),
      name:  field_name(object, attribute),
      id:    field_name(object, attribute),
      class: class_name(object, attribute)
    }
  end

  def text_field(object, attribute)
    input_field(object, attribute, 'text')
  end

  def password_field(object, attribute)
    input_field(object, attribute, 'password')
  end

  def hidden_field(object, attribute)
    input_field(object, attribute, 'hidden')
  end

  def input_field(object, attribute, field_type)
    haml_tag :input, field_options(object, attribute).merge(
      type: field_type
    )
  end

  def check_box(object, attribute)
    haml_tag :input, field_options(object, attribute).merge(
      type: 'checkbox',
      checked: object.send(attribute),
      value: 'yes'
    )
  end

  def label(object, attribute, content = attribute.to_s.titleize)
    haml_tag :label, for: field_name(object, attribute) do
      haml_concat content
    end
  end

end
