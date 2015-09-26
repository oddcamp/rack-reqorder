module Rack::Reqorder::Models
  class Statistic
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document
    include ::Mongoid::Timestamps

    field :http_requests_count, type: Integer, default: 0
    #field :sum
    #field :square_sum
    #field :sd_response_time
    field :avg_response_time, type: Float, default: 0
    field :statuses_2xx, type: Integer, default: 0
    field :statuses_3xx, type: Integer, default: 0
    field :statuses_4xx, type: Integer, default: 0
    field :statuses_401, type: Integer, default: 0
    field :statuses_404, type: Integer, default: 0
    field :statuses_422, type: Integer, default: 0
    field :statuses_5xx, type: Integer, default: 0

    field :xhr_count, type: Integer, default: 0
    field :ssl_count, type: Integer, default: 0

    embedded_in :route_path, inverse_of: :statistic_all

    0.upto(23) do |i|
      embedded_in :route_path, inverse_of: "statistic_#{i}"
    end

    def recalculate_average!(response_time)
      self.avg_response_time = (
        response_time + (self.http_requests_count-1)*self.avg_response_time
      )/self.http_requests_count
    end
  end
end
