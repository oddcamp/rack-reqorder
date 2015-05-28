module Rack::Reqorder::Models
  class HttpResponse
    include ::Mongoid::Document

    field :headers, type: Hash
    field :status, type: Integer
    #field :body, type: String
    field :created_at, type: DateTime

    before_create :set_created_at

    def set_created_at
      self.created_at = DateTime.now.utc
    end
  end
end
