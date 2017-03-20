require 'sinatra/base'
require 'rack/reqorder/monitor/web/entity_decorator'
require 'rack/reqorder/monitor/web/helpers'
require 'rack/reqorder/monitor/web/controllers/base_controller'

class Rack::Reqorder::Monitor::Web::Application < Sinatra::Application
  P = Rack::Reqorder::Monitor::Web
  M = Rack::Reqorder::Models

  helpers P::Helpers::ViewHelpers

  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views") }
  set :method_override, true

  get '/?' do
    erb(:dashboard, {
      layout: :layout,
      locals: P::Controllers::Base.new(params).resolve
    })
  end

  get '/errors/?' do
    erb(:faults, {
      layout: :layout,
      locals: P::Controllers::Errors.new(params).resolve
    })
  end

  get '/errors/:id/?' do
    erb(:fault, {
      layout: :layout,
      locals: P::Controllers::Error.new(params).resolve
    })
  end

  put '/errors/:id/toggle' do
    M::AppFault.find(params['id']).tap{|f| f.resolved = !f.resolved; f.save!}

    path = params['redirect_to'] == 'index' ? '/errors' : "/errors/#{params['id']}"

    redirect(to(path))
  end

  get '/recordings/?' do
    erb(:recordings, {
      layout: :layout,
      locals: P::Controllers::Recordings.new(params).resolve
    })
  end

  post '/recordings' do
    M::Recording.create!({
      http_header: params['recording']['http_header'],
      http_header_value: params['recording']['http_header_value']
    })

    redirect(to("/recordings"))
  end

  put '/recordings/:id/toggle' do
    M::Recording.find(params['id']).tap{|r| r.enabled = !r.enabled; r.save!}
    path = params['redirect_to'] == 'index' ? '/recordings' : "/recordings/#{params['id']}"

    redirect(to(path))
  end

  get '/recordings/:id/?' do
    erb(:recording, {
      layout: :layout,
      locals: P::Controllers::Recording.new(params).resolve
    })
  end

  delete '/recordings/:id' do
    M::Recording.find(params['id']).destroy!

    redirect(to("/recordings"))
  end

  delete '/recordings/:id/requests' do
    M::Recording.find(params['id']).http_requests.destroy_all

    path = params['redirect_to'] == 'index' ? '/recordings' : "/recordings/#{params['id']}"

    redirect(to(path))
  end

  get '/requests/:id/?' do
    erb(:request, {
      layout: :layout,
      locals: P::Controllers::Request.new(params).resolve
    })
  end

  get '/metrics/?' do
    erb(:metrics, {
      layout: :layout,
      locals: P::Controllers::Metrics.new(params).resolve
    })
  end

  put '/configuration/?' do
    configuration = M::Configuration.all.first
    [:metrics, :exception, :request].map(&:to_s).each do |option|
      if params[option]
        configuration.send("#{option}_monitoring=", truthy_param(params[option]))
        configuration.save!
      end
    end

    params['redirect_to'] ? redirect(to(params['redirect_to'])) : redirect(to("/"))
  end

  delete '/data/?' do
    Rack::Reqorder.clean_database!

    redirect(to("/"))
  end
end
