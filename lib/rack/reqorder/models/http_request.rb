module Rack::Reqorder::Models
  class HttpRequest
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document
    include ::Mongoid::Timestamps

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
    field :param_keys, type: Array
    field :ssl, type: Boolean
    field :xhr, type: Boolean
    field :response_time, type: Float

    has_one :http_response, dependent: :destroy
    has_one :app_exception, dependent: :destroy

    belongs_to :route_path, dependent: :nullify

    before_create :add_param_keys
  private
    def add_param_keys
      self.param_keys = self.params.keys
    end
  end
end
