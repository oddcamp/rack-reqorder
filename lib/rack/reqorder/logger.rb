module Rack
  module Reqorder
    class Logger
      include Rack::Reqorder::Models

      def initialize(app)
        @app = app
      end

      def call(environment)
        #api_session = ApiSession.create(created_at: Time.now)
        request = Rack::Request.new(environment)
        #api_session.request

        HttpRequest.create(
          path: request.path,
          full_path: request.fullpath,
          headers: extract_all_headers(request),
          parameters: request.params,
        )

        status, headers, body = @app.call(request.env)

        response = Rack::Response.new(body, status, headers)

        HttpResponse.create(
          headers: response.headers,
          #body: response.body.first,
          status: response.status.to_i
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
          }
        ]
      end
    end
  end
end
