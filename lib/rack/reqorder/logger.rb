module Rack::Reqorder
  class Logger
    include Rack::Reqorder::Models

    def initialize(app)
      @app = app
    end

    def call(environment)
      http_request = save_http_request(environment)

      begin
        status, headers, body = @app.call(environment)
      rescue => exception
        log_exception(exception, http_request)
        raise exception
      end

      save_http_response(body, status, headers, http_request)

      return [status, headers, body]
    end

  private

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

    def save_http_request(environment)
      request = Rack::Request.new(environment)

      route_path = RoutePath.find_or_create_by({
        route: Rack::Reqorder.recognise_path(request.path),
        http_method: request.request_method
      })

      HttpRequest.create({
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
        xhr: request.xhr?,
        route_path: route_path
      })
    end

    def save_http_response(body, status, headers, http_request)
      response = Rack::Response.new(body, status, headers)

      HttpResponse.create(
        headers: response.headers,
        #body: response.body.first,
        status: response.status.to_i,
        http_request: http_request
      )
    end

    def log_exception(exception, http_request)
      bc = BacktraceCleaner.new
      bc.add_filter   { |line| line.gsub(Rails.root.to_s, '') }
      bc.add_silencer { |line| line =~ /gems/ }

      application_trace = bc.clean(exception.backtrace)

      path = line = nil

      if not application_trace.blank?
        path, line, _ = application_trace.first.split(':')
      else
        path, line, _ = exception.backtrace.first.split(':')
      end


      app_fault = AppFault.find_or_create_by(
        e_class: exception.class,
        line: line.to_i,
        filepath: path[1..-1]
      )

      AppException.create(
        e_class: exception.class,
        message: exception.message,
        application_trace: application_trace,
        full_trace: exception.backtrace,
        line: line.to_i,
        filepath: path[1..-1],
        source_extract: source_fragment(path[1..-1], line.to_i),
        app_fault: app_fault,
        http_request: http_request
      )

      HttpResponse.create(
        status: 500,
        http_request: http_request
      )
    end

    def source_fragment(path, line)
      return unless Rails.respond_to?(:root) && Rails.root

      full_path = Rails.root.join(path)
      if File.exist?(full_path)
        File.open(full_path, "r") do |file|
          start = [line - 3, 0].max
          lines = file.each_line.drop(start).take(6)
          Hash[*(start+1..(lines.count+start)).zip(lines).flatten]
        end
      end
    end
  end
end
