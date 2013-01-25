require 'spec_helper'

describe Feed::Tumblr do
  subject { new_tumblr_feed }

  its(:url) { should be_nil }

  describe "#info=" do
    context "when info is a username" do
      before { subject.info = 'dam5s' }
      its(:url) { should == 'http://dam5s.tumblr.com/rss' }
    end

    context "when info is a tumblr page" do
      context "with a tumblr sub-domain" do
        context "without trailing slash" do
          before { subject.info = 'http://dam5s.tumblr.com' }
          its(:url) { should == 'http://dam5s.tumblr.com/rss' }
        end

        context "with trailing slash" do
          before { subject.info = 'http://dam5s.tumblr.com/' }
          its(:url) { should == 'http://dam5s.tumblr.com/rss' }
        end

        context "without protocol" do
          before { subject.info = "dam5s.tumblr.com" }
          its(:url) { should == "http://dam5s.tumblr.com/rss" }
        end
      end

      context "with a custom domain" do
        context "without trailing slash" do
          before { subject.info = 'http://dam5s.net' }
          its(:url) { should == 'http://dam5s.net/rss' }
        end

        context "with trailing slash" do
          before { subject.info = 'http://dam5s.net/' }
          its(:url) { should == 'http://dam5s.net/rss' }
        end

        context "with www" do
          before { subject.info = 'http://www.dam5s.net/' }
          its(:url) { should == 'http://dam5s.net/rss' }
        end

        context "without protocol" do
          before { subject.info = "dam5s.net" }
          its(:url) { should == "http://dam5s.net/rss" }
        end
      end
    end

    context "when info is a tumblr rss feed" do
      context "with a tumblr sub-domain" do
        before { subject.info = 'http://dam5s.tumblr.com/rss' }
        its(:url) { should == 'http://dam5s.tumblr.com/rss' }
      end

      context "with a custom domain" do
        before { subject.info = 'http://dam5s.net/rss' }
        its(:url) { should == 'http://dam5s.net/rss' }
      end

      context "with a custom domain and www" do
        before { subject.info = 'http://www.dam5s.net/rss' }
        its(:url) { should == 'http://dam5s.net/rss' }
      end
    end
  end
end
