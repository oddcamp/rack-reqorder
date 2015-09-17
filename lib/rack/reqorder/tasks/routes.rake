if respond_to?(:namespace, true)
  namespace 'rack-reqorder' do
    desc 'rack-monitor API routes'
    task :routes => :environment do
      Rack::Reqorder::Monitor::Api.routes.each do |route|
        puts route
      end
    end
  end
end
