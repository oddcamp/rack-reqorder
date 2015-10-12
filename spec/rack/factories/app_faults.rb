FactoryGirl.define do
  factory :app_fault, class: Rack::Reqorder::Models::AppFault  do
    e_class { 'foobar' }
    line { rand(0...400) }
    filepath { 'mysuperfile.rb' }

    environment { ['development', 'staging'].sample }

    app_exceptions_count { rand(0..100) }

    created_at { rand(0..120).hours.ago }
    updated_at { created_at }
  end
end

