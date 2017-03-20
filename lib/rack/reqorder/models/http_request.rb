module Rack::Reqorder::Models
  class HttpRequest
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :ip, type: String
    field :url, type: String
    field :body, type: String
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

    belongs_to :route_path, {dependent: :nullify}.merge(NOT_REQUIRED)
    belongs_to :recording, {dependent: :nullify}.merge(NOT_REQUIRED)

    before_create :add_param_keys
    after_save :update_recording_requests_count, if: :recording_id

    def has_body?
      return false unless http_method

      return false if [:head, :get].include?(http_method.to_s.downcase.to_sym)

      return true
    end

    private
      def add_param_keys
        self.param_keys = self.params.keys
      end

      def update_recording_requests_count
        self.recording.update_requests_count!
      end
  end
end
