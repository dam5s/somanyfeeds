require 'spec_helper'

describe User::Authentication do

  subject { User.make_unsaved }

  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:username) }

  describe 'authenticate' do

    before do
      User.delete_all
      subject.save!
    end

    it 'should find user by email/password' do
      User.authenticate(subject.email, subject.password).should == subject
    end

    it 'should find user by username/password' do
      User.authenticate(subject.username, subject.password).should == subject
    end

  end

end
