module Rack::Reqorder::Models
  class Request < Ohm::Model
    include Ohm::DataTypes
    include Ohm::Callbacks

    attribute :path
    attribute :full_path
    attribute :headers, Type::Hash
    attribute :parameters, Type::Hash
    attribute :created_at, Type::Time

    reference :response, :HttpResponse

  protected
    def before_create
      self.created_at = Time.now
    end

  end
end
