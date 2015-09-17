module Rack::Reqorder::Models
  class RoutePath
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document
    include ::Mongoid::Timestamps

    field :route, type: String
    field :http_method, type: String

    has_many :http_requests, dependent: :destroy

    embeds_one :statistic_all, class_name: 'Rack::Reqorder::Models::Statistic'

    0.upto(23) do |i|
      embeds_one "statistic_#{i}", class_name: 'Rack::Reqorder::Models::Statistic'
    end

    has_one :app_fault, dependent: :destroy
  end
end
