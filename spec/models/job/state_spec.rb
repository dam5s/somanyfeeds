require 'spec_helper'

describe Job::State do

  subject { @job ||= Job.make }

  after(:all) do
    subject.delete
  end

  context "job's state is queued" do

    before { subject.state = 'queued' }

    its(:queued?) { should be_true }
    its(:done?)   { should be_false }

    describe 'done!' do

      before { subject.done! && subject.reload }

      its(:done?)   { should be_true }
      its(:queued?) { should be_false }

    end

  end

  context "job's state is done" do

    before { subject.state = 'done' }

    its(:done?)   { should be_true }
    its(:queued?) { should be_false }

    describe 'queued!' do

      before { subject.queued! && subject.reload }

      its(:queued?) { should be_true }
      its(:done?)   { should be_false }

    end

  end

  describe 'queued and done' do

    before do
      3.times { Job.make state: 'queued' }
      2.times { Job.make state: 'done' }
    end

    it 'queued should list queued jobs' do
      Job.queued.all.each{|j| j.state.should == 'queued'}
    end

    it 'done should list done jobs' do
      Job.done.all.each{|j| j.state.should == 'done'}
    end

  end

end
