module Rack::Reqorder::Models
  class AppFault
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document
    include ::Mongoid::Timestamps

    field :e_class, type: String
    field :line, type: Integer
    field :filepath, type: String

    field :resolved, type: Boolean, default: false

    field :environment, type: String

    field :app_exceptions_count, type: Integer, default: 0

    has_many :app_exceptions, dependent: :destroy

    def update_count!
      self.app_exceptions_count = self.app_exceptions.count
      self.save!
    end
  end
end
