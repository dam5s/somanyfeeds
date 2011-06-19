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

  subject { page }

  describe 'initial page with 2 out of 3 feeds' do

    before do
      visit '/'
    end

    it { should have_css('article.github', count: 5) }
    it { should have_css('a.selected', text: 'Github') }

    it { should have_css('article.tumblr', count: 5) }
    it { should have_css('a.selected', text: 'Tumblr') }

    it { should_not have_css('article.twitter') }
    it { should_not have_css('a.selected', text: 'Twitter') }
    it { should have_css('a', text: 'Twitter') }

    describe 'select one more feed' do

      before do
        click_on 'Twitter'
      end

      it { should have_css('article.github', count: 5) }
      it { should have_css('a.selected', text: 'Github') }

      it { should have_css('article.tumblr', count: 5) }
      it { should have_css('a.selected', text: 'Tumblr') }

      it { should have_css('article.twitter', count: 5) }
      it { should have_css('a.selected', text: 'Twitter') }

      describe 'deselect one feed' do

        before do
          click_on 'Github'
        end

        it { should_not have_css('article.github') }
        it { should have_css('article.tumblr', count: 5) }
        it { should have_css('article.twitter', count: 5) }

        describe 'select only one feed' do

          before do
            click_on 'Tumblr'
          end

          it { should_not have_css('article.github') }
          it { should_not have_css('a.selected', text: 'Github') }
          it { should have_css('a', text: 'Github') }

          it { should_not have_css('article.tumblr') }
          it { should_not have_css('a.selected', text: 'Tumblr') }
          it { should have_css('a', text: 'Tumblr') }

          it { should have_css('article.twitter', count: 5) }
          it { should have_css('a.selected', text: 'Twitter') }

          describe 'deselect last selected feed should select default feeds' do

            before do
              click_on 'Twitter'
            end

            it { should have_css('article.github', count: 5) }
            it { should have_css('a.selected', text: 'Github') }

            it { should have_css('article.tumblr', count: 5) }
            it { should have_css('a.selected', text: 'Tumblr') }

            it { should_not have_css('article.twitter') }
            it { should_not have_css('a.selected', text: 'Twitter') }
            it { should have_css('a', text: 'Twitter') }

          end

        end

      end

    end

  end

end
