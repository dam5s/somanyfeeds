module Mailer

  def self.send_password_recovery( user )
    return unless user.email.present?

    message  = "Someone requested to reset your password. If that's you, you may do with the following link:"
    message << " http://somanyfeeds.com/reset-password/#{user.reset_hash}"

    deliver subject: "Reset your SoManyFeeds.com password",
            body: message,
            to: user.email
  end

private

  def self.deliver(options = {})
    return if %w(development test).include? RACK_ENV

    Mail.deliver do
      to       options[:to]
      from     config[:from]
      subject  options[:subject]

      text_part do
        body options[:body]
      end
    end
  end

  def self.config
    MAIL_CONFIG
  end

end
