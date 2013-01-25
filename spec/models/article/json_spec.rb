require 'spec_helper'

describe Article::JSON do
  describe "#as_json" do
    before(:all) do
      @user = create_user
      @user.feeds << new_feed( name: 'Foo', slug: 'foo' )
      @article = new_article(user: @user, source: 'foo')
    end

    subject { @article.as_json(nil).keys }

    [ :created_at, :updated_at ].each do |key|
      it { should_not include( key ) }
    end

    [ :id, :link, :title, :feed_name, :datetime,
      :display_date, :content, :source ].each do |key|
      it { should include( key ) }
    end
  end
end
