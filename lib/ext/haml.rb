module Haml::Precompiler

  def render_div(line)
    raise SyntaxError.new "Haml running in strict mode, # and . shortcuts disabled"
  end

end
