require 'spec_helper'

describe User do

  subject { User.make }

  before(:all) do
    User.delete_all

    subject.feeds = (0..4).map do |num|
      Feed.new(name: "Some Feed #{num}", default: true)
    end
  end

  after(:all) { User.delete_all }


  describe 'Persistence' do

    it { should be_valid }
    it { should embed_many(:feeds) }

  end

  describe '#to_label' do

    before(:all) do
      subject.name = 'Foo'
      subject.username = 'Bar'
      subject.email = 'foo@bar.baz'
    end

    context 'with name' do
      its(:to_label) { should == 'Foo' }
    end

    context 'without name' do
      before { subject.name = nil }
      its(:to_label) { should == 'Bar' }
    end

    context 'without name, without username' do
      before { subject.name = nil; subject.username = nil }
      its(:to_label) { should == 'foo@bar.baz' }
    end

  end

  describe '#default_sources and #all_sources' do

    it "should be a list of feed slugs" do
      (subject.default_sources + subject.all_sources).each do |src|
        src.should =~ /^Some-Feed-[0-4]$/
      end
    end

    it "#default_sources should only include feeds with the default flag" do
      subject.default_sources.size.should == 5
      subject.all_sources.size.should == 5

      feed = subject.feeds.last
      feed.default = false
      feed.save

      subject.default_sources.size.should == 4
      subject.all_sources.size.should == 5
    end

  end

  describe '#update!' do

    it "should call update on each feed" do
      subject.feeds.each{|f| f.should_receive(:update!)}
      subject.update!
    end

    context "with a deleted feed" do

      before do
        3.times { Article.make user: subject, source: 'Foo' }
        subject.articles.size.should == 3
        subject.update!
        subject.reload
      end

      its(:articles) { should be_empty }

    end

  end

  describe '#feed' do

    subject { User.make_unsaved }

    before(:all) do
      subject.feeds = [Feed.make_unsaved]
      subject.save!

      @id = subject.feeds.last.id
    end

    after(:all) do
      subject.destroy
    end

    it 'should find a user feed with corresponding id' do
      subject.feed(@id).should be_present
    end

    it 'should return nil if no feed found' do
      subject.feed(BSON::ObjectId.new).should be_blank
    end

  end

end
