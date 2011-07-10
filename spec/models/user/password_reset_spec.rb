require 'spec_helper'

describe User::PasswordReset do

  after { User.delete_all }

  describe ".send_password_reset_email!" do

    context "with an existing email" do

      before { @user = User.make(email: "d@somanyfeeds.com") }

      it "should find the user" do
        u = User.send_password_reset_email! "d@somanyfeeds.com"
        u.should == @user
      end

      it "should send email to the user" do
        User.should_receive(:where) { [ @user ] }
        @user.should_receive :send_password_reset_email!
        User.send_password_reset_email! "d@somanyfeeds.com"
      end

    end

    context "with an email that doesn't match any user" do

      it "should return nil" do
        u = User.send_password_reset_email! "foo@bar.com"
        u.should be_nil
      end

    end

  end

  describe "#send_password_reset_email!" do

    subject { User.make }

    before do
      Mailer.should_receive(:send_password_recovery).with(subject)
      subject.send_password_reset_email!
    end

    its(:reset_hash) { should_not be_blank }
    its(:reset_hash_created_at) { should_not be_blank }

  end

end
