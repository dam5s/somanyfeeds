require 'spec_helper'

describe Feed::Twitter do

  subject { Feed::Twitter.make_unsaved }

  its(:url) { should be_nil }

  describe "#info=" do

    context "when info is a username" do

      before { subject.info = 'its_damo' }
      its(:url) { should == 'http://twitter.com/statuses/user_timeline/its_damo.rss' }

    end

    context "when info is a twitter page" do

      context "without trailing slash" do
        before { subject.info = 'http://twitter.com/its_damo' }
        its(:url) { should == 'http://twitter.com/statuses/user_timeline/its_damo.rss' }
      end

      context "with trailing slash" do
        before { subject.info = 'http://twitter.com/its_damo/' }
        its(:url) { should == 'http://twitter.com/statuses/user_timeline/its_damo.rss' }
      end

      context "without protocol" do
        before { subject.info = 'twitter.com/its_damo' }
        its(:url) { should == 'http://twitter.com/statuses/user_timeline/its_damo.rss' }
      end

      context "with www" do
        before { subject.info = 'http://www.twitter.com/its_damo' }
        its(:url) { should == 'http://twitter.com/statuses/user_timeline/its_damo.rss' }
      end

      context "with she-bang" do
        before { subject.info = 'http://twitter.com/#!/its_damo' }
        its(:url) { should == 'http://twitter.com/statuses/user_timeline/its_damo.rss' }
      end

    end

    context "when info is a twitter rss feed" do

      context "without www" do
        before { subject.info = 'http://twitter.com/statuses/user_timeline/its_damo.rss' }
        its(:url) { should == 'http://twitter.com/statuses/user_timeline/its_damo.rss' }
      end

      context "without protocol" do
        before { subject.info = 'twitter.com/statuses/user_timeline/its_damo.rss' }
        its(:url) { should == 'http://twitter.com/statuses/user_timeline/its_damo.rss' }
      end

      context "with https and www" do
        before { subject.info = 'https://www.twitter.com/statuses/user_timeline/its_damo.rss' }
        its(:url) { should == 'https://twitter.com/statuses/user_timeline/its_damo.rss' }
      end

    end

  end

end
