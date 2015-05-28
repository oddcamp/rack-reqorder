module Rack::Reqorder::Models
  class HttpRequest
    include ::Mongoid::Document

    field :path, type: String
    field :full_path, type: String
    field :headers, type: Hash
    field :parameters, type: Hash
    field :created_at, type: DateTime

    has_one :http_response

    before_create :set_created_at

    def set_created_at
      self.created_at = DateTime.now.utc
    end

  end
end
