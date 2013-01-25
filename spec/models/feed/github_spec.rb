require 'spec_helper'

describe Feed::Github do
  subject { new_github_feed }

  its(:url) { should be_nil }

  describe "#info=" do
    context "when info is a username" do

      before { subject.info = 'dam5s' }
      its(:url) { should == 'https://github.com/dam5s.atom' }
    end

    context "when info is a github page" do
      context "with https" do
        context "without trailing slash" do
          before { subject.info = 'https://github.com/dam5s' }
          its(:url) { should == 'https://github.com/dam5s.atom' }
        end

        context "with trailing slash" do
          before { subject.info = 'https://github.com/dam5s/' }
          its(:url) { should == 'https://github.com/dam5s.atom' }
        end
      end

      context "with http" do
        context "without trailing slash" do
          before { subject.info = 'http://github.com/dam5s' }
          its(:url) { should == 'https://github.com/dam5s.atom' }
        end

        context "with trailing slash" do
          before { subject.info = 'http://github.com/dam5s/' }
          its(:url) { should == 'https://github.com/dam5s.atom' }
        end
      end

      context "without protocol" do
        before { subject.info = "github.com/dam5s" }
        its(:url) { should == "https://github.com/dam5s.atom" }
      end
    end

    context "when info is a github atom feed" do
      context "with http" do
        before { subject.info = 'http://github.com/dam5s.atom' }
        its(:url) { should == 'https://github.com/dam5s.atom' }
      end

      context "with https" do
        before { subject.info = 'https://github.com/dam5s.atom' }
        its(:url) { should == 'https://github.com/dam5s.atom' }
      end
    end
  end
end
