require 'sham'
require 'forgery'

Sham.title       { Forgery::LoremIpsum.sentence + Forgery::Basic.text }
Sham.link        { "http://#{Forgery::Internet.domain_name}/#{Forgery::Basic.text}" }
Sham.description { Forgery::LoremIpsum.paragraph + Forgery::Basic.text }
Sham.date        { Forgery::Date.date }
Sham.entry_id    { Forgery::Basic.text }
Sham.source      { %w(Twitter Delicious Flickr Blog Tumblr).random }

Sham.username    { Forgery::Internet.user_name }
Sham.email       { Forgery::Internet.email_address }
Sham.password    { Forgery::Basic.password }
Sham.password_confirmation { Sham.password }

Article.blueprint do
  title
  description
  date
  entry_id
  source
end

User.blueprint do
  username
  email
  password
  password_confirmation
end

User.blueprint(:registered) do
  registered { true }
end

User.blueprint(:visitor) do
  registered { false }
  email { nil }
end

Feed.blueprint do
  name    { Sham.source }
  url     { Sham.link }
  default { true }
end

Feed::Blog.blueprint       { name{'Blog'}; url{nil} }
Feed::Github.blueprint     { name{'Github'}  }
Feed::Twitter.blueprint    { name{'Twitter'} }
Feed::Tumblr.blueprint     { name{'Tumblr'}  }
Feed::Delicious.blueprint  { name{'Delicious'} }
