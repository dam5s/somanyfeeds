require 'spec_helper'

describe Article::JSON do

  describe "#as_json" do

    before(:all) do
      @user = User.make_unsaved
      @user.feeds << Feed.make_unsaved( name: 'Foo', slug: 'foo' )
      @article = Article.make_unsaved(user: @user, source: 'foo')
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
