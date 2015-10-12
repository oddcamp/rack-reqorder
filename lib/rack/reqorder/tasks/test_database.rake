if respond_to?(:namespace, true)
  namespace 'rack-reqorder' do
    desc 'rack-monitor API routes'
    task :test_database => :environment do
      env = ENV["RACK_ENV"] || ENV["RAILS_ENV"] || Rails.env
      return 'Available only under development env' unless env == 'development'

      require_relative '../../../../spec/rack/factories/statistics.rb'
      require_relative '../../../../spec/rack/factories/route_paths.rb'
      require_relative '../../../../spec/rack/factories/app_faults.rb'

      10.times { FactoryGirl.create(:route_path) }

      FactoryGirl.create(
        :route_path,
        route: '/rack-reqorder/api/v1/route_path_24_statistics',
        http_method: 'GET'
      )

      FactoryGirl.create(
        :route_path,
        route: '/rack-reqorder/api/v1/route_paths',
        http_method: 'GET'
      )

      40.times { FactoryGirl.create(:app_fault) }
    end
  end
end
