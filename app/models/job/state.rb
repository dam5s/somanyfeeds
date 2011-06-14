module Job::State

  STATES = %w( queued done )

  extend ActiveSupport::Concern

  included do

    field :state, type: String
    before_create :init_state

    STATES.each do |state|
      scope state.to_sym, where(state: state)

      define_method "#{state}!" do
        update_attribute :state, state
      end

      define_method "#{state}?" do
        self.state == state
      end
    end

  end

  def init_state
    self.state ||= 'queued'
  end

end
