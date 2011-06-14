require 'spec_helper'

describe User::Registration do

  describe 'visitor' do

    subject { User.create_visitor! }

    it { should_not be_registered }
    it { should be_valid }

  end

end
