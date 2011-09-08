require 'gmail'

class Mailer

  include Singleton

  attr_accessor :account, :password, :from, :gmail

  def initialize
    self.account  = MAIL_CONFIG[:account]
    self.password = MAIL_CONFIG[:password]
    self.from     = MAIL_CONFIG[:from]
    self.gmail    = nil
  end

  def connect( &block )
    self.gmail = Gmail.new( account, password )
    yield
    self.gmail.logout
    self.gmail = nil
  end

  def send_password_recovery( user )
    return unless user.email.present?

    message  = "Someone requested to reset your password. If that's you, you may do so using the following link:"
    message << " http://somanyfeeds.com/reset-password/#{user.reset_hash}"

    deliver subject: "Reset your SoManyFeeds.com password",
            body: {text: message},
            to: user.email
  end

  #
  # Delegate everything to #instance
  #
  def self.method_missing(method, *args, &block)
    if self.instance.respond_to? method
      return self.instance.send(method, *args, &block)
    end

    super
  end

private

  def deliver( options = {} )
    return if %w(development test).include? RACK_ENV
    return connect_and_deliver( options ) if gmail.nil?

    gmail.deliver do
      to      options[:to]
      from    self.from
      subject options[:subject]

      if options[:body][:text]
        text_part do
          body options[:body][:text]
        end
      end

      if options[:body][:html]
        html_part do
          body options[:body][:html]
        end
      end
    end
  end

  def connect_and_deliver( options )
    connect do
      deliver options
    end
  end

end
