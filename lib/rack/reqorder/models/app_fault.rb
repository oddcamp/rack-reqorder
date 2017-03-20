module Rack::Reqorder::Models
  class AppFault
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :e_class, type: String
    field :line, type: Integer
    field :filepath, type: String

    field :last_seen_at, type: Time

    field :resolved, type: Boolean, default: false

    field :environment, type: String

    field :app_exceptions_count, type: Integer, default: 0

    has_many :app_exceptions, dependent: :destroy

    def update_count!
      self.app_exceptions_count = self.app_exceptions.count
      self.last_seen_at = DateTime.now
      self.save!
    end

    def message
      app_exceptions.try(:last).try(:message)
    end

  end
end
