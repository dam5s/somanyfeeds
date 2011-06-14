module Article::JSON

  def datetime
    date.strftime('%Y-%m-%dT%H:%M:%S%z').insert(-3, ':')
  end

  def display_date
    date.strftime('%B %d, %Y')
  end

  def content
    description.to_s.sub(
      %r{<script src="http://gist\.github\.com/([a-z0-9]+)\.js(.*)"></script>},
      %q{<a href="https://gist.github.com/\1\2" class="gist">View Source on Github</a>}
    )
  end

  def as_json( options = nil )
    attributes = [ :id, :link, :title, :feed_name,
      :datetime, :display_date, :content, :source ]

    Hash.from_keys( attributes ) { |attr| send(attr) }
  end

end
