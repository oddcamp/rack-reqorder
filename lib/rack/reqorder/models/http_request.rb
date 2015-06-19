module Rack::Reqorder::Models
  class HttpRequest
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document

    field :ip, type: String
    field :url, type: String
    field :scheme, type: String
    field :base_url, type: String
    field :port, type: Integer
    field :path, type: String
    field :full_path, type: String
    field :http_method, type: String
    field :headers, type: Hash
    field :params, type: Hash
    field :ssl, type: Boolean
    field :xhr, type: Boolean
    field :created_at, type: Time, default: ->{ Time.now }

    has_one :http_response
    has_one :app_exception

  end
end
