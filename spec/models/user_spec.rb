require 'spec_helper'

describe User do
  subject { @user }

  before do
    User.delete_all
    @user = create_user

     (0..4).each do |num|
       @user.feeds << Feed.new(name: "Some Feed #{num}", default: true)
    end
  end

  after { User.delete_all }

  describe 'Persistence' do
    it { should be_valid }
    it { should embed_many(:feeds) }
  end

  describe '#to_label' do
    before do
      @user.name = 'Foo'
      @user.username = 'Bar'
      @user.email = 'foo@bar.baz'
    end

    context 'with name' do
      its(:to_label) { should == 'Foo' }
    end

    context 'without name' do
      before { @user.name = nil }
      its(:to_label) { should == 'Bar' }
    end

    context 'without name, without username' do
      before { @user.name = nil; @user.username = nil }
      its(:to_label) { should == 'foo@bar.baz' }
    end
  end

  describe '#default_sources and #all_sources' do
    it "should be a list of feed slugs" do
      (@user.default_sources + @user.all_sources).each do |src|
        src.should =~ /^Some-Feed-[0-4]$/
      end
    end

    it "#default_sources should only include feeds with the default flag" do
      @user.default_sources.size.should == 5
      @user.all_sources.size.should == 5

      feed = @user.feeds.last
      feed.default = false
      feed.save

      @user.default_sources.size.should == 4
      @user.all_sources.size.should == 5
    end
  end

  describe '#update!' do
    it "should call update on each feed" do
      @user.feeds.each{|f| f.should_receive(:update!)}
      @user.update!
    end

    context "with a deleted feed" do
      before do
        3.times { new_article user: @user, source: 'Foo' }
        @user.articles.size.should == 3
        @user.update!
        @user.reload
      end

      its(:articles) { should be_empty }
    end
  end

  describe '#feed' do
    before do
      @user = new_user
      @user.feeds = [new_feed]
      @user.save!

      @id = @user.feeds.last.id
    end

    after do
      @user.destroy
    end

    it 'should find a user feed with corresponding id' do
      @user.feed(@id).should be_present
    end

    it 'should return nil if no feed found' do
      @user.feed(Moped::BSON::ObjectId.new).should be_blank
    end
  end
end
