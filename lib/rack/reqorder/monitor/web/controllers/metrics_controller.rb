module Rack::Reqorder::Monitor::Web::Controllers
  class Metrics < P::Base
    def resolve
      slow_route_paths = Rack::Reqorder::Models::RoutePath.order_by(
        'statistic_all.avg_response_time' => :desc
      ).limit(5).to_a

      popular_route_paths = Rack::Reqorder::Models::RoutePath.order_by(
        'statistic_all.http_requests_count' => :desc
      ).limit(5).to_a

      return super({
        slow_route_paths: slow_route_paths,
        popular_route_paths: popular_route_paths,
        total_metrics: total_metrics
      })
    end

    private
      def total_metrics
        statuses = {
          avg_response_time: :avg,
          http_requests_count: :sum,
          statuses_2xx: :sum,
          statuses_3xx: :sum,
          statuses_4xx: :sum,
          statuses_5xx: :sum,
          statuses_401: :sum,
          statuses_404: :sum,
          statuses_422: :sum,
          xhr_count: :sum,
          ssl_count: :sum,
        }

        return statuses.inject(OpenStruct.new) do |memo, (key, aggr)|
          memo[key] = M::RoutePath.all.send(aggr, "statistic_all.#{key}")
          memo
        end
      end
  end
end

