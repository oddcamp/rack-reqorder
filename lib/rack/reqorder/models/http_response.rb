module Rack::Reqorder::Models
  class HttpResponse
    include ::Mongoid::Document

    field :headers, type: Hash
    field :status, type: Integer
    #field :body, type: String
    field :created_at, type: DateTime
    field :response_time, type: Integer

    belongs_to :http_request

    before_create :before_create_setup

    private
    def before_create_setup
      set_created_at
      set_response_time
    end

    def set_created_at
      self.created_at = DateTime.now.utc.strftime('%Q').to_i
    end

    def set_response_time
      self.response_time = self.created_at.to_i - self.http_request.created_at.to_i
    end
  end
end
