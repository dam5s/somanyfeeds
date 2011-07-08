require 'spec_helper'

describe Article do

  describe 'Persistence' do

    subject { Article.make_unsaved }

    it { should be_valid }
    it { should be_embedded_in :user }

  end

  describe '#feed_name' do

    before(:all) do
      @user = User.make_unsaved
      @user.feeds << Feed.make_unsaved( name: 'Foo', slug: 'foo' )
    end

    subject { Article.make_unsaved(user: @user, source: 'foo') }

    its(:feed_name) { should == 'Foo' }

  end

end
