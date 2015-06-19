module Rack
  module Reqorder
    class Logger
      include Rack::Reqorder::Models

      def initialize(app)
        @app = app
      end

      def call(environment)
        request = Rack::Request.new(environment)

        http_request = HttpRequest.create(
          ip: request.ip,
          url: request.url,
          scheme: request.scheme,
          base_url: request.base_url,
          port: request.port,
          path: request.path,
          full_path: request.fullpath,
          http_method: request.request_method,
          headers: extract_all_headers(request),
          params: request.params,
          ssl: request.ssl?,
          xhr: request.xhr?
        )

        status, headers, body = @app.call(request.env)

        response = Rack::Response.new(body, status, headers)

        HttpResponse.create(
          headers: response.headers,
          #body: response.body.first,
          status: response.status.to_i,
          http_request: http_request
        )
=begin
        response.finish
=end
        return [status, headers, body]
      end

      def extract_all_headers(request)
        Hash[
          request.env.select{|k,v|
            k.start_with? 'HTTP_'
          }.map{|k,v|
            [k.gsub('HTTP_','').upcase, v]
          }.select{|k,v|
            k != 'COOKIE'
          }
        ]
      end
    end
  end
end
