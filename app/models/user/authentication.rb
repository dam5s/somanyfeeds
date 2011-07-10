require "digest/sha2"

module User::Authentication

  extend ActiveSupport::Concern

  included do

    attr_accessor :password, :password_confirmation

    field :email,         type: String
    field :username,      type: String
    field :password_hash, type: String
    field :password_salt, type: String

    before_save :prepare_password

    validates_uniqueness_of :username, :email, allow_blank: true, if: :registered?
    validates_format_of     :username, with: /^[-\w\._@]+$/i, allow_blank: true, message: "should only contain letters, numbers, or .-_@"
    validates_format_of     :email,    with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+([a-z0-9]{2,4}\.)?[a-z0-9]{2,4}$/i, allow_blank: true

    validates_length_of :password, minimum: 4, allow_blank: true, if: :registered?
    validate            :password_validation, if: :registered?

    index :username, unique: true
    index :email, unique: true

  end

  module InstanceMethods

    def password_validation
      if new_record? || password_hash.blank?
        errors.add(:password, 'should be present') if password.blank?
      end

      if password.present?
        errors.add(:password_confirmation, 'does not match password') if password_confirmation != password
      end
    end

    def matching_password?(pass)
      self.password_hash == encrypt_password(pass)
    end

    def prepare_password
      unless password.blank?
        self.password_salt = Digest::SHA512.hexdigest([Time.now, rand].join)
        self.password_hash = encrypt_password(password)
      end
    end

    def encrypt_password(pass)
      digest = [pass, '--B4Z1NG4H--', password_salt].join
      20.times { digest = Digest::SHA512.hexdigest(digest) }
      digest
    end

  end

  module ClassMethods

    # Login can be either username or email address
    def authenticate(login, pass)
      user = first(conditions: {username: login}) || first(conditions: {email: login})
      return user if user && user.matching_password?(pass)
    end

  end

end
