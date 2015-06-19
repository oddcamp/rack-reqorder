module Rack::Reqorder::Monitor
  module Entities
    class BaseEntity < Grape::Entity
      expose :_id, documentation: { type: 'String', desc: 'BSON::ObjectId String' }, :format_with => :to_string, as: :id
      format_with(:to_string) { |foo| foo.to_s }
      format_with(:iso_timestamp) { |dt| dt.utc.iso8601 if dt }

      format_with(:association_id) {|a| a.id.to_s if a}
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
      expose :ssl
      expose :xhr

      with_options(format_with: :iso_timestamp) do
        expose :created_at
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
      end

      with_options(format_with: :association_id) do
        expose :http_request, as: :request_id
      end
    end


    class ExceptionEntity < BaseEntity
      root :exceptions, :exception

      expose :message
      expose :application_trace
      expose :full_trace
      expose :line
      expose :path
      expose :source_extract

      with_options(format_with: :iso_timestamp) do
        expose :created_at
      end

      with_options(format_with: :association_id) do
        expose :http_request, as: :request_id
      end

    end
  end
end
