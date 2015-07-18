module Rack::Reqorder::Models
  class RoutePath
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document
    include ::Mongoid::Timestamps

    field :route, type: String
    field :http_method, type: String
    field :http_requests_count, type: Integer
    #field :sum
    #field :square_sum
    field :avg_response_time, type: Float
    #field :sd_response_time

    has_many :http_requests, dependent: :destroy

    before_save :set_aggregated_attrs!

    def set_aggregated_attrs!
      self.http_requests_count = self.http_requests.count
      self.avg_response_time = self.http_requests.avg(:response_time)
      self.save!
    end
  end
end
