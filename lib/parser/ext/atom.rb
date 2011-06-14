class RSS::Atom::Feed::Entry

  include Parser::Entry

  def date
    updated.content
  end

  def link
    links.find do |l|
      l.rel=='alternate' &&
        l.type=='text/html'
    end.href
  end

  alias atom_title title
  def title
    atom_title.content
  end

  def description
    content && content.content || summary && summary.content
  end

  def entry_id
    id.content
  end

end
