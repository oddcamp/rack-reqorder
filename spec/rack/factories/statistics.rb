FactoryGirl.define do
  factory :statistic, class: Rack::Reqorder::Models::Statistic  do
    http_requests_count { rand(10000..11000) }
    avg_response_time { rand(0.0...1.0) }
    statuses_2xx { http_requests_count - rand(1000..2000) }
    statuses_3xx { http_requests_count - rand(9500..10000) }
    statuses_4xx { http_requests_count - rand(8000..10000) }
    statuses_5xx { http_requests_count - rand(9800..10000) }

    xhr_count { http_requests_count - rand(9000..10000) }
    ssl_count { http_requests_count - rand(1000..2000) }

    created_at { 1.day.ago }
    updated_at { 1.day.ago }
  end
end
