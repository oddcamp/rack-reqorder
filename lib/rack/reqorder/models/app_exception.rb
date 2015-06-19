#Heavy influenced by ActionDispatch::DebugExceptions

module Rack::Reqorder::Models
  class AppException
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document

    field :message, type: String
    field :application_trace, type: Array
    #field :framework_trace, type: Array
    field :full_trace, type: Array
    field :line, type: Integer
    field :path, type: String
    field :source_extract, type: Hash
    field :created_at, type: Time, default: ->{ Time.now }

    belongs_to :http_request
  end
end
