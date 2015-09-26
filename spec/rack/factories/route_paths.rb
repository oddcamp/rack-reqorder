FactoryGirl.define do
  factory :route_path, class: Rack::Reqorder::Models::RoutePath  do
    route { "api/v1/#{Faker::Lorem.word}" }
    http_method { ["GET", "POST", "PUT", "DELETE"].sample }

    statistic_0 { FactoryGirl.build(:statistic) }
    statistic_1 { FactoryGirl.build(:statistic) }
    statistic_2 { FactoryGirl.build(:statistic) }
    statistic_3 { FactoryGirl.build(:statistic) }
    statistic_4 { FactoryGirl.build(:statistic) }
    statistic_5 { FactoryGirl.build(:statistic) }
    statistic_6 { FactoryGirl.build(:statistic) }
    statistic_7 { FactoryGirl.build(:statistic) }
    statistic_8 { FactoryGirl.build(:statistic) }
    statistic_9 { FactoryGirl.build(:statistic) }
    statistic_10 { FactoryGirl.build(:statistic) }
    statistic_11 { FactoryGirl.build(:statistic) }
    statistic_12 { FactoryGirl.build(:statistic) }
    statistic_13 { FactoryGirl.build(:statistic) }
    statistic_14 { FactoryGirl.build(:statistic) }
    statistic_15 { FactoryGirl.build(:statistic) }
    statistic_16 { FactoryGirl.build(:statistic) }
    statistic_17 { FactoryGirl.build(:statistic) }
    statistic_18 { FactoryGirl.build(:statistic) }
    statistic_19 { FactoryGirl.build(:statistic) }
    statistic_20 { FactoryGirl.build(:statistic) }
    statistic_21 { FactoryGirl.build(:statistic) }
    statistic_22 { FactoryGirl.build(:statistic) }
    statistic_23 { FactoryGirl.build(:statistic) }

    statistic_all { FactoryGirl.build(:statistic) }
  end
end
