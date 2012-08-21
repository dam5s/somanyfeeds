require 'spec_helper'

def create_user_for_acceptance

  user = User.make_unsaved

  user.feeds << Feed::Twitter.make_unsaved(default: false)
  user.feeds << Feed::Github.make_unsaved
  user.feeds << Feed::Tumblr.make_unsaved

  user.save!

  user.feeds.each do |feed|
    5.times do
      user.articles << Article.make(source: feed.slug)
    end
  end

  user

end

describe SoManyFeeds::Aggregator do

  before(:all) do
    create_user_for_acceptance
  end

  after(:all) do
    User.delete_all
  end

  it 'should know which feeds to display' do

    # Display default feeds
    visit '/'

    page.should have_css('article.github', count: 5)
    page.should have_css('a.selected', text: 'Github')
    page.should_not have_css('article.github.hidden')

    page.should have_css('article.tumblr', count: 5)
    page.should have_css('a.selected', text: 'Tumblr')
    page.should_not have_css('article.tumblr.hidden')

    page.should_not have_css('article.twitter')
    page.should_not have_css('a.selected', text: 'Twitter')
    page.should have_css('a', text: 'Twitter')

    # Add Twitter
    click_on 'Twitter'

    page.should have_css('article.github', count: 5)
    page.should have_css('a.selected', text: 'Github')
    page.should_not have_css('article.github.hidden')

    page.should have_css('article.tumblr', count: 5)
    page.should have_css('a.selected', text: 'Tumblr')
    page.should_not have_css('article.tumblr.hidden')

    page.should have_css('article.twitter', count: 5)
    page.should have_css('a.selected', text: 'Twitter')
    page.should_not have_css('article.twitter.hidden')

    # Remove Github
    click_on 'Github'

    page.should have_css('a', text: 'Github')
    page.should_not have_css('a.selected', text: 'Github')
    page.should have_css('article.github.hidden')

    page.should have_css('article.tumblr', count: 5)
    page.should have_css('a.selected', text: 'Tumblr')
    page.should_not have_css('article.tumblr.hidden')

    page.should have_css('article.twitter', count: 5)
    page.should have_css('a.selected', text: 'Twitter')
    page.should_not have_css('article.twitter.hidden')

    # Remove TUmblr, only twitter remains
    click_on 'Tumblr'

    page.should have_css('article.github.hidden', count: 5)
    page.should have_css('a', text: 'Github')
    page.should_not have_css('a.selected', text: 'Github')

    page.should have_css('article.tumblr.hidden', count: 5)
    page.should have_css('a', text: 'Tumblr')
    page.should_not have_css('a.selected', text: 'Tumblr')

    page.should have_css('article.twitter', count: 5)
    page.should have_css('a.selected', text: 'Twitter')
    page.should_not have_css('article.twitter.hidden')

    # Remove last, restore default feeds
    click_on 'Twitter'

    page.should have_css('article.github', count: 5)
    page.should have_css('a.selected', text: 'Github')
    page.should_not have_css('article.github.hidden')

    page.should have_css('article.tumblr', count: 5)
    page.should have_css('a.selected', text: 'Tumblr')
    page.should_not have_css('article.tumblr.hidden')

    page.should_not have_css('article.twitter')
    page.should_not have_css('a.selected', text: 'Twitter')
    page.should have_css('a', text: 'Twitter')

  end

end
