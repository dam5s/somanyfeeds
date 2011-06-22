require 'spec_helper'

def create_user_for_integration

  user = User.make_unsaved(:registered)

  user.feeds << Feed::Twitter.make_unsaved(default: false)
  user.feeds << Feed::Github.make_unsaved
  user.feeds << Feed::Tumblr.make_unsaved

  user.save!

  user.feeds.each do |feed|
    5.times { Article.make(source: feed.slug, user: user) }
  end

  user

end

describe SoManyFeeds::Aggregator, js: true do

  before(:all) do
    create_user_for_integration
  end

  after(:all) do
    User.delete_all
    Article.delete_all
  end

  it 'should display 2 default feeds' do

    visit '/'

    page.should have_css('article.github', count: 5)
    page.should have_css('a.selected', text: 'Github')

    page.should have_css('article.tumblr', count: 5)
    page.should have_css('a.selected', text: 'Tumblr')

    page.should_not have_css('article.twitter')
    page.should_not have_css('a.selected', text: 'Twitter')
    page.should have_css('a', text: 'Twitter')

  end

  it 'should select one more feed' do

    click_on 'Twitter'

    page.should have_css('article.github', count: 5)
    page.should have_css('a.selected', text: 'Github')

    page.should have_css('article.tumblr', count: 5)
    page.should have_css('a.selected', text: 'Tumblr')

    page.should have_css('article.twitter', count: 5)
    page.should have_css('a.selected', text: 'Twitter')

  end

  it 'should deselect one feed' do

    click_on 'Github'

    page.should_not have_css('article.github')
    page.should have_css('article.tumblr', count: 5)
    page.should have_css('article.twitter', count: 5)

  end

  it 'should select only one feed' do

    click_on 'Tumblr'

    page.should_not have_css('article.github')
    page.should_not have_css('a.selected', text: 'Github')
    page.should have_css('a', text: 'Github')

    page.should_not have_css('article.tumblr')
    page.should_not have_css('a.selected', text: 'Tumblr')
    page.should have_css('a', text: 'Tumblr')

    page.should have_css('article.twitter', count: 5)
    page.should have_css('a.selected', text: 'Twitter')

  end

  it 'should select back default feeds' do

    click_on 'Twitter'

    page.should have_css('article.github', count: 5)
    page.should have_css('a.selected', text: 'Github')

    page.should have_css('article.tumblr', count: 5)
    page.should have_css('a.selected', text: 'Tumblr')

    page.should_not have_css('article.twitter')
    page.should_not have_css('a.selected', text: 'Twitter')
    page.should have_css('a', text: 'Twitter')

  end

end
