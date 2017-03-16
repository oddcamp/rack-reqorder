require 'grape'
require 'grape-entity'
require 'mongoid_hash_query'

module Rack::Reqorder
  module Monitor
    module Api
    end
  end
end

require 'rack/reqorder/monitor/api/helpers'
require 'rack/reqorder/monitor/api/entities'

module Rack::Reqorder::Monitor::Api

  class Api < Grape::API
    include Rack::Reqorder::Models
    include Rack::Reqorder::Monitor::Api::Entities

    helpers do
      include MongoidHashQuery
      include Rack::Reqorder::Monitor::Api::Helpers
    end

    version 'v1', using: :path, vendor: 'foobar'
    format :json
    prefix :api

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({errors: e.send(:full_messages)}, 422)
    end

    before do
      header 'Access-Control-Allow-Origin', '*'
      header 'Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD'
      header 'Access-Control-Allow-Headers', 'Content-Type'
    end

    #collection routes
    resource :route_paths do
      before do
        authorize_user!(headers) unless Rack::Reqorder.configuration.no_auth
      end

      get do
        route_paths = apply_filters(RoutePath.all, params)

        meta_aggregations = aggregations(route_paths, params)

        route_paths = paginate(route_paths, params)

        present_with_meta(
          route_paths,
          present(route_paths, with: RoutePathEntity),
          meta_aggregations
        )
      end

      delete do
        route_paths = RoutePath.delete_all

        present_with_meta(
          route_paths,
          present(route_paths, with: RoutePathEntity)
        )
      end

      #element routes
      route_param :id do
        get do
          present(RoutePath.find(params[:id]), with: RoutePathEntity)
        end
      end
    end

    #collection routes
    resource :route_path_24_statistics do
      get do
        route_paths = RoutePath.all

        route_paths = apply_filters(route_paths, params)

        present(route_paths, with: RoutePath24StatisticsEntity)
      end
    end

    #collection routes
    resource :requests do
      before do
        authorize_user!(headers) unless Rack::Reqorder.configuration.no_auth
      end

      get do
        requests = apply_filters(HttpRequest.all, params)

        meta_aggregations = aggregations(requests, params)

        requests = paginate(requests, params)

        present_with_meta(
          requests,
          present(requests, with: RequestEntity),
          meta_aggregations
        )
      end

      delete do
        requests = HttpRequest.delete_all

        present_with_meta(
          requests,
          present(requests, with: RequestEntity)
        )
      end

      #element routes
      route_param :id do
        get do
          present(HttpRequest.find(params[:id]), with: RequestEntity)
        end
      end
    end

    #collection routes
    resource :responses do
      before do
        authorize_user!(headers) unless Rack::Reqorder.configuration.no_auth
      end

      get do
        responses = HttpResponse.all

        responses = apply_filters(responses, params)

        meta_aggregations = aggregations(responses, params)

        responses = paginate(responses, params)

        present_with_meta(
          responses,
          present(responses, with: ResponseEntity),
          meta_aggregations
        )
      end

      delete do
        responses = HttpResponse.delete_all

        present_with_meta(
          responses,
          present(responses, with: ResponseEntity)
        )
      end

      #element routes
      route_param :id do
        get do
          present(HttpResponse.find(params[:id]), with: ResponseEntity)
        end
      end
    end

    #collection routes
    resource :faults do
      before do
        authorize_user!(headers) unless Rack::Reqorder.configuration.no_auth
      end

      get do
        faults = AppFault.all

        environments = faults.group_by(&:environment).keys

        faults = apply_filters(faults, params)

        meta_aggregations = aggregations(faults, params)

        faults = paginate(faults, params)

        present_with_meta(
          faults,
          present(faults, with: FaultEntity),
          meta_aggregations.merge(environments: environments)
        )
      end

      delete do
        faults = AppFault.delete_all

        present_with_meta(
          faults,
          present(faults, with: FaultEntity)
        )

      end

      #element routes
      route_param :id do
        get do
          present(AppFault.find(params[:id]), with: FaultEntity)
        end

        params do
          requires :fault, type: Hash do
            optional :resolved, type: Boolean
          end
        end
        put do
          fault = AppFault.find(params[:id])
          fault.resolved = declared(params)[:fault][:resolved]
          fault.save!

          present(fault, with: FaultEntity)
        end
      end
    end

    #collection routes
    resource :exceptions do
      before do
        authorize_user!(headers) unless Rack::Reqorder.configuration.no_auth
      end

      get do
        exceptions = AppException.all

        exceptions = apply_filters(exceptions, params)

        meta_aggregations = aggregations(exceptions, params)

        exceptions = paginate(exceptions, params)

        present_with_meta(
          exceptions,
          present(exceptions, with: ExceptionEntity),
          meta_aggregations
        )
      end

      delete do
        exceptions = AppException.delete_all

        present_with_meta(
          exceptions,
          present(exceptions, with: ExceptionEntity)
        )
      end

      #element routes
      route_param :id do
        get do
          present(AppException.find(params[:id]), with: ExceptionEntity)
        end
      end
    end

    #collection routes
    resource :recordings do
      before do
        authorize_user!(headers) unless Rack::Reqorder.configuration.no_auth
      end

      get do
        recordings = apply_filters(Recording.all, params)

        meta_aggregations = aggregations(recordings, params)

        recordings = paginate(recordings, params)

        present_with_meta(
          recordings,
          present(recordings, with: RecordingEntity),
          meta_aggregations
        )
      end

      params do
        requires :recording, type: Hash do
          requires :http_header, type: String
          requires :http_header_value, type: String
        end
      end
      post do
        present(
          Recording.create!({
            http_header: declared(params)[:recording][:http_header],
            http_header_value: declared(params)[:recording][:http_header_value]
          }),
          with: RecordingEntity
        )
      end

      #element routes
      route_param :id do
        get do
          present(Recording.find(params[:id]), with: RecordingEntity)
        end

        delete do
          recording = Recording.find(params[:id])
          recording.destroy

          present(recording, with: RecordingEntity)
        end
      end
    end

    params do
      requires :user, type: Hash do
        requires :email, type: String
        requires :password, type: String
      end
    end
    resource :sessions do
      post do
        authenticate_user!(declared(params))

        present(Object.new, with: SessionEntity)
      end
    end

    helpers do
      def present_with_meta(object, hash, extra_meta)
        hash[:meta] = {
          current_page: object.current_page,
          next_page: object.next_page,
          prev_page: object.prev_page,
          total_pages: object.total_pages,
          total_count: object.total_count
        }.merge(extra_meta)

        return hash
      end

      def paginate(object, params)
        object = object.page(params[:page] || 1).per(params[:per_page] || 30)
        object = object.skip(params[:skip]) if params[:skip]

        return object
      end
    end

  end
end
