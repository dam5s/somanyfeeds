require 'spec_helper'

describe Feed::Delicious do

  subject { Feed::Delicious.make_unsaved }

  its(:url) { should be_nil }

  describe "#info=" do

    context "when info is a username" do

      before { subject.info = 'dam5s' }
      its(:url) { should == 'http://feeds.delicious.com/v2/rss/dam5s' }

    end

    context "when info is a delicious page" do

      context "without trailing slash" do
        before { subject.info = 'http://delicious.com/dam5s' }
        its(:url) { should == 'http://feeds.delicious.com/v2/rss/dam5s' }
      end

      context "with trailing slash" do
        before { subject.info = 'http://delicious.com/dam5s/' }
        its(:url) { should == 'http://feeds.delicious.com/v2/rss/dam5s' }
      end

      context "without protocol" do
        before { subject.info = 'delicious.com/dam5s/' }
        its(:url) { should == 'http://feeds.delicious.com/v2/rss/dam5s' }
      end

      context "with www" do
        before { subject.info = 'www.delicious.com/dam5s/' }
        its(:url) { should == 'http://feeds.delicious.com/v2/rss/dam5s' }
      end

      context "with the old domain name" do
        before { subject.info = 'del.icio.us/dam5s' }
        its(:url) { should == 'http://feeds.delicious.com/v2/rss/dam5s' }
      end

    end

    context "when info is a delicious rss feed" do

      before { subject.info = 'http://feeds.delicious.com/v2/rss/dam5s' }
      its(:url) { should == 'http://feeds.delicious.com/v2/rss/dam5s' }

    end

  end

end
