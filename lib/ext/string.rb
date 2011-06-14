class String

  def to_slug
    slug = self.gsub(/[^0-9a-zA-Z]+/, '-')
    slug.gsub!(/^-|-$/, '')
    slug
  end

  def normalize_url(domain = nil)
    cleaned = self.dup

    cleaned.gsub!("//www.", "//")
    cleaned.gsub!(/^www./, "")

    return cleaned if domain.nil?

    cleaned.match(/^http(s?):/) ? cleaned : "http://#{cleaned}"
  end

  def dasherize
    underscore.gsub '_', '-'
  end

end
