require 'grape'
require 'grape-entity'
require 'rack/reqorder/monitor/entities'
require 'mongoid_hash_query'
require 'pry'

module Rack::Reqorder
  module Monitor
  end
end

module Rack::Reqorder::Monitor
  class Api < Grape::API
    include Rack::Reqorder::Models
    include Rack::Reqorder::Monitor::Entities

    helpers do
      include MongoidHashQuery
    end

    version 'v1', using: :path, vendor: 'foobar'
    format :json
    prefix :api

    #collection routes
    resource :route_paths do
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

      #element routes
      route_param :id do
        get do
          present(RoutePath.find(params[:id]), with: RoutePathEntity)
        end
      end
    end

    #collection routes
    resource :requests do
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

      #element routes
      route_param :id do
        get do
          present(HttpRequest.find(params[:id]), with: RequestEntity)
        end
      end
    end

    #collection routes
    resource :responses do
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

      #element routes
      route_param :id do
        get do
          present(HttpResponse.find(params[:id]), with: ResponseEntity)
        end
      end
    end

    #collection routes
    resource :faults do
      get do
        faults = AppFault.all

        faults = apply_filters(faults, params)

        meta_aggregations = aggregations(faults, params)

        faults = paginate(faults, params)

        present_with_meta(
          faults,
          present(faults, with: FaultEntity),
          meta_aggregations
        )
      end

      #element routes
      route_param :id do
        get do
          present(AppFault.find(params[:id]), with: FaultEntity)
        end
      end
    end

    #collection routes
    resource :exceptions do
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

      #element routes
      route_param :id do
        get do
          present(AppException.find(params[:id]), with: ExceptionEntity)
        end
      end
    end

    helpers do
      def present_with_meta(object, hash, extra_meta)
        hash[:meta] = {
          currentPage: object.current_page,
          nextPage: object.next_page,
          prevPage: object.prev_page,
          totalPages: object.total_pages,
          totalCount: object.total_count
        }.merge(extra_meta)

        return hash
      end

      def paginate(object, params)
        return object.
          page(params[:page] || 1).
          per(params[:per_page] || 30).
          skip(params[:skip] || 0)
      end
    end

  end
end
