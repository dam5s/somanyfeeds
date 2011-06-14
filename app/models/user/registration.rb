module User::Registration

  extend ActiveSupport::Concern

  included do
    field :registered, type: Boolean, default: false
  end

  module InstanceMethods

    def registered?
      registered
    end

    def visitor?
      !registered?
    end

  end

  module ClassMethods

    def create_visitor!
      User.create!(
        site_name: 'All My Feeds',
        username: 'visitor',
        name: 'John Doe'
      )
    end

  end

end
