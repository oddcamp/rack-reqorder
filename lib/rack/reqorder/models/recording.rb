module Rack::Reqorder::Models
  class Recording
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :http_header, type: String
    field :http_header_value, type: String
    field :enabled, type: Boolean, default: true
    field :requests_count, type: Integer, default: 0

    has_many :http_requests, dependent: :nullify
    has_many :http_responses, dependent: :nullify

    scope :enabled, -> {where(enabled: true)}

    def rack_http_header
      http_header.gsub('-','_').upcase
    end

    def update_requests_count!
      self.requests_count = self.http_requests.count
      self.save!
    end
  end
end
