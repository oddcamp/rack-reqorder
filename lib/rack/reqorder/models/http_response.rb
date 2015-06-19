module Rack::Reqorder::Models
  class HttpResponse
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document

    field :headers, type: Hash
    field :status, type: Integer
    #field :body, type: String
    field :created_at, type: Time, default: ->{ Time.now }, pre_processed: true
    field :response_time, type: Float

    belongs_to :http_request

    before_create :set_response_time

  private
    def set_response_time
      self.response_time = self.created_at - self.http_request.created_at
    end
  end
end
