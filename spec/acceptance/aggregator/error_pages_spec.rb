require 'spec_helper'

describe SoManyFeeds::Aggregator do

  before(:all) do
    User.make(site_name: "Damien's feeds") # make sure we escape the quote
  end

  after(:all) do
    User.delete_all
  end

  subject { page }

  context 'as a visitor I access the home page' do

    before do
      visit '/'
    end

    it 'should render html' do
      page.response_headers['Content-Type'].should =~ %r[text/html]
    end

    it { should have_css('section.main') }
    it { should_not have_css('article') }
    it { should have_content('you got lost') }

  end

  context 'as a visitor I access the feed' do

    before do
      visit '/index.rss'
    end

    it 'should render rss' do
      page.response_headers['Content-Type'].should =~ %r[application/rss\+xml]
    end

    it { should_not have_xpath('//rss') }

  end

end
