require 'spec_helper'

describe Article do

  describe "Persistence" do

    subject { Article.make_unsaved }

    it { should be_valid }
    it { should be_referenced_in :user }

  end

  describe "JSON format" do

    subject { Article.make_unsaved.encode_json(nil) }

    it { should_not =~ /"created_at"/ }
    it { should_not =~ /"updated_at"/ }
    it { should_not =~ /"_id"/ }

  end

end
