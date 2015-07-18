module Rack::Reqorder::Monitor
  module Entities
    class BaseEntity < Grape::Entity
      expose :_id, documentation: { type: 'String', desc: 'BSON::ObjectId String' }, :format_with => :to_string, as: :id
      format_with(:to_string) { |foo| foo.to_s }
      format_with(:iso_timestamp) { |dt| dt.utc.iso8601 if dt }

      format_with(:association_id) {|a| a.id.to_s if a }
      format_with(:association_ids) {|a| a.map{|i| i.to_s if i} if a }
    end

    class RoutePathEntity < BaseEntity
      root :route_paths, :route_path

      expose :route
      expose :http_method
      expose :http_requests_count
      expose :avg_response_time

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end

    class RequestEntity < BaseEntity
      root :requests, :request

      expose :ip
      expose :url
      expose :scheme
      expose :base_url
      expose :port
      expose :path
      expose :full_path
      expose :http_method
      expose :headers
      expose :params
      expose :param_keys
      expose :ssl
      expose :xhr
      expose :response_time

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end

      with_options(format_with: :association_id) do
        expose :http_response, as: :response_id
      end

    end

    class ResponseEntity < BaseEntity
      root :responses, :response

      expose :headers
      expose :status
      expose :response_time

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end

      with_options(format_with: :association_id) do
        expose :http_request, as: :request_id
      end
    end

    class FaultEntity < BaseEntity
      root :faults, :fault

      expose :e_class, as: :class
      expose :line
      expose :filepath
      expose :count

      with_options(format_with: :association_ids) do
        expose :app_exception_ids, as: :exception_ids
      end

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end

    class ExceptionEntity < BaseEntity
      root :exceptions, :exception

      expose :message
      expose :application_trace
      expose :full_trace
      expose :line
      expose :filepath
      expose :source_extract

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end

      with_options(format_with: :association_id) do
        expose :http_request, as: :request_id
      end

    end
  end
end
