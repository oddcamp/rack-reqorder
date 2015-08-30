module Rack::Reqorder::Models
  class RoutePath
    include ::Mongoid::Document
    include ::Kaminari::MongoidExtension::Document
    include ::Mongoid::Timestamps

    field :route, type: String
    field :http_method, type: String

    has_many :http_requests, dependent: :destroy

    embeds_one :statistic_0, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_1, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_2, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_3, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_4, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_5, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_6, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_7, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_8, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_9, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_10, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_11, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_12, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_13, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_14, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_15, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_16, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_17, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_18, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_19, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_20, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_21, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_22, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_23, class_name: 'Rack::Reqorder::Models::Statistic'
    embeds_one :statistic_24, class_name: 'Rack::Reqorder::Models::Statistic'

    embeds_one :statistic_all, class_name: 'Rack::Reqorder::Models::Statistic'

    has_one :app_fault, dependent: :destroy
  end
end
