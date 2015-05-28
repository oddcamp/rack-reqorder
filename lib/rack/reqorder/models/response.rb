module Rack::Reqorder::Models
  class Response < Ohm::Model
    include Ohm::DataTypes

    attribute :headers, Type::Hash
    attribute :status, Type::Integer

    attribute :created_at, Type::Time
  end
end
