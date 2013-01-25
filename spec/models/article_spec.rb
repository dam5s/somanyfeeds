require 'spec_helper'

describe Article do
  describe 'Persistence' do
    subject { new_article }

    it { should be_valid }
    it { should be_embedded_in :user }
  end

  describe '#feed_name' do
    before(:all) do
      @user = new_user
      @user.feeds << new_feed( name: 'Foo', slug: 'foo' )
    end

    subject { new_article(user: @user, source: 'foo') }

    its(:feed_name) { should == 'Foo' }
  end
end
