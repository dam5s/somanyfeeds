require 'spec_helper'

describe Feed do
  describe 'factory' do
    describe 'should handle unknown types' do
      subject { Feed.factory('Unkown', name: 'Foo') }

      its(:class) { should be Feed::Blog }
      its(:name) { should == 'Foo' }
    end

    describe 'should handle types without Feed namespace' do
      subject { Feed.factory('Github', name: 'Bar') }

      its(:class) { should be Feed::Github }
      its(:name) { should == 'Bar' }
    end

    describe 'should handle full class names' do
      subject { Feed.factory('Feed::Tumblr', name: 'Baz') }

      its(:class) { should be Feed::Tumblr }
      its(:name) { should == 'Baz' }
    end
  end

  describe 'default' do
    describe 'without param' do
      it 'should default to a Feed::Blog' do
        Feed::Blog.should_receive(:default) { 'foo' }
        Feed.default.should == 'foo'
      end

      it 'should handle types without Feed namespace ' do
        Feed::Github.should_receive(:default) { 'bar' }
        Feed.default('Github').should == 'bar'
      end

      it 'should handle full class names ' do
        Feed::Tumblr.should_receive(:default) { 'baz' }
        Feed.default('Feed::Tumblr').should == 'baz'
      end
    end
  end

  describe 'Persistence' do
    subject { new_feed }

    it { should be_valid }
    it { should be_embedded_in(:user).as_inverse_of(:feeds) }
  end

  describe 'slug' do
    before(:all) { @user = create_user }
    after(:all) { @user.delete }
    subject { @feed }

    context 'with a clean name' do
      before do
        @user.feeds << @feed = new_feed(name: 'Blog')
        @feed.save!
      end

      its(:slug) { should == 'Blog' }
    end

    context 'with unsupported characters' do
      before do
        @user.feeds << @feed = new_feed(name: 'My Blog (in french)')
        @feed.save!
      end

      its(:slug) { should == 'My-Blog-in-french' }
    end
  end

  describe '#articles' do
    before(:all) do
      @user = create_user
      @user.feeds << @feed = new_feed(name: 'Foo')
      @user.feeds << new_feed(name: 'Bar')
      @user.save!

      @articles = []

      3.times do
        @articles << new_article(user: @user, source: 'Foo')
      end

      @articles << new_article(user: @user, source: 'Bar')
      @articles << new_article(user: create_user, source: 'Foo')
    end

    after(:all) do
      @user.destroy
      @articles.each{|a| a.destroy}
    end

    it "should include user's articles with corresponding source" do
      @feed.articles.size.should == 3
    end

    describe 'renaming source renames articles' do
      before(:all) do
        @feed.name = 'Baz'
        @feed.save!
      end

      it "should have renamed articles' source" do
        @feed.articles.size.should == 3
      end
    end
  end
end
