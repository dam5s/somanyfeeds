require 'spec_helper'

describe Job do

  before(:all) do
    @user = User.make
    @feed = Feed.make
    @user.feeds << @feed
    @user.save!
  end

  after(:all) do
    @user.delete
    Job.delete_all
  end

  subject { @job ||= Job.make(user: @user, feed_id: @feed.id) }

  its(:feed)  { should == @feed }
  its(:state) { should == 'queued' }

  describe 'run_all!' do

    before do
      @jobs = 3.times.map do |j|
        Job.make_unsaved.tap do |job|
          job.should_receive :run!
        end
      end

      Job.should_receive(:queued) { mock('jobs', :all => @jobs) }
    end

    it 'should call run! on all queued jobs' do
      Job.run_all!
    end

  end

  describe 'queue' do

    before do
      Job.delete_all
      Job.queue(@feed)
    end

    it 'should have created a job for the given feed' do
      Job.first.feed.should == @feed
    end

  end

  describe '#run!' do

    before do
      subject.stub!(:feed) { @feed }
    end

    context 'job is queued' do

      it 'should update the feed, change state to "done", and save!' do
        @feed.should_receive :update!

        subject.run!
        subject.reload.state.should == 'done'
      end

    end

  end

end
