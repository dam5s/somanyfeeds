require "digest/sha2"

module User::PasswordReset

  extend ActiveSupport::Concern

  included do
    field :reset_hash,            type: String
    field :reset_hash_created_at, type: Time

    index :reset_hash, unique: true
  end

  def send_password_reset_email!
    generate_password_reset_hash
    ::Mailer.send_password_recovery self
  end

  module ClassMethods

    def send_password_reset_email! email
      u = User.where(email: email).first
      u.try :send_password_reset_email!
      u
    end

  end

private

  def generate_password_reset_hash
    h = Digest::SHA512.hexdigest [password_salt, password_hash, username, Time.now.to_s].join('--')

    update_attribute :reset_hash, h
    update_attribute :reset_hash_created_at, Time.now
  end

end
