require 'spec_helper'

describe Daemons::Job do

  before(:all) do
    @feed = Feed.make_unsaved
  end

  subject { @job ||= Daemons::Job.new(@feed, priority: :high) }

  its(:feed) { should == @feed }
  its(:key)  { should == "jobs.high" }

  describe 'queue' do

    before do
      @the_job = mock
    end

    it 'should have created a job for the given feed' do
      Daemons::Job.should_receive(:new) { @the_job }
      @the_job.should_receive(:publish!)

      Daemons::Job.queue(@feed, priority: :high)
    end

  end

  describe '#run!' do

    before do
      subject.stub!(:feed) { @feed }
    end

    it 'should update the feed, change state to "done", and save!' do
      @feed.should_receive :update!
      subject.run!
    end

  end

end
