module Rack::Reqorder::Models
  class HttpRequest
    include ::Mongoid::Document

    field :ip, type: String
    field :url, type: String
    field :scheme, type: String
    field :base_url, type: String
    field :port, type: Integer
    field :path, type: String
    field :full_path, type: String
    field :method, type: String
    field :headers, type: Hash
    field :params, type: Hash
    field :ssl, type: Boolean
    field :xhr, type: Boolean
    field :created_at, type: DateTime

    has_one :http_response

    before_create :set_created_at

    def set_created_at
      self.created_at = DateTime.now.utc.strftime('%Q').to_i
    end

  end
end
