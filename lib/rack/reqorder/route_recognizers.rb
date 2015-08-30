module Rack
  module Reqorder
    module RailsRecognizer
      def prefixes
        return @prefixes unless @prefixes.blank?

        @prefixes = {} #{'/mount_prefix' => {search_method: xxx_recognize_path, rack_app: xxx}}
        Rails.application.routes.routes.routes.select{|r| r.defaults.blank?}.each do |route|
          __superclass = route.app.try(:superclass) || route.app.try(:app).try(:superclass)

          next unless __superclass

          case __superclass.to_s
          when Sinatra::Base.to_s
            @prefixes[route.path.spec.try(:left).to_s + route.path.spec.try(:right).to_s] = {
              search_method: :sinatra_recognize_path,
              rack_app: route.app.try(:superclass).nil? ? route.app.app : route.app
            }
          when Rails::Engine.to_s
            @prefixes[route.path.spec.try(:left).to_s + route.path.spec.try(:right).to_s] = {
              search_method: :rails_recognize_path,
              rack_app: route.app.try(:superclass).nil? ? route.app.app : route.app
            }
          when Grape::API.to_s
            @prefixes[route.path.spec.try(:left).to_s + route.path.spec.try(:right).to_s] = {
              search_method: :grape_recognize_path,
              rack_app: route.app.try(:superclass).nil? ? route.app.app : route.app
            }
          end
        end

        return @prefixes
      end

      def rails_paths(rails_app)
        paths = {}
        rails_app.routes.routes.routes.reverse.each do |route|
          paths[route.defaults] = route.path.spec.to_s.gsub('(.:format)', '')
        end

        return paths
      end

      def recognize_unknown_path
        prefixes.each do |prefix, engine|
          if path_uri.start_with?(prefix)
            return prefix
          end
        end

        return ''
      end

      def recognize_path(path_uri, options = {})
        prefixes.each do |prefix, engine|
          if path_uri.start_with?(prefix)
            return prefix + self.send(engine[:search_method].to_sym, {
              path_uri: path_uri.gsub(prefix, ''),
              rack_app: engine[:rack_app],
              options: options
            })
          end
        end

        begin
          return rails_recognize_path(
            path_uri: path_uri,
            rack_app: Rails.application,
            options: options
          )
        rescue ActionController::RoutingError
          return "/#{path_uri.split('/')[1]}"
        end
      end

      #rack_app is basically a rails app here but we keep it for the sake of the interface
      def rails_recognize_path(path_uri:, rack_app:, options: {})
        memoized_var = "@#{rack_app.class.to_s.split('::').join('_').downcase}".to_sym

        if self.instance_variable_get(memoized_var).nil?
          self.instance_variable_set(memoized_var, rails_paths(rack_app))
        end

        Rack::Reqorder.instance_variable_get(memoized_var)[
          rack_app.routes.recognize_path(path_uri, options)
          .select{|key, value| [:action, :controller].include?(key)}
        ]
      end
    end

    module GrapeRecognizer
      def recognize_path(path_uri, options = {})
        raise 'not implemented yet'
      end

      def grape_recognize_path(path_uri:, rack_app:, options: {})
        path_uri = '/' if path_uri.blank?

        rack_app.routes.each do |route|
          route_options = route.instance_variable_get(:@options)
          if route_options[:method] == options[:method] && route_options[:compiled] =~ path_uri
           # if route_options[:method] == "OPTIONS"
           #   return route_options[:path].
           #     gsub('(.json)', '')
           # else
              return route_options[:path].
                gsub(':version', route_options[:version]).
                gsub('(.json)', '')
           # end
          end
        end

        #assets in grape? well you never know..
        if path_uri.end_with?('.js')
          return '/js_asset'
        elsif path_uri.end_with?('.css')
          return '/css_asset'
        elsif path_uri.end_with?('.png', 'jpg')
          return '/css_asset'
        else
          return '/unknown' #path_uri
        end
      end
    end

    module SinatraRecognizer
      def recognize_path(path_uri, options = {})
        raise 'not implemented yet'
      end

      def sinatra_recognize_path(path_uri:, rack_app:, options: {})
        path_uri = '/' if path_uri.blank?

        rack_app.routes[options[:method].to_s.upcase].each do |r|
          if r.first =~ path_uri
            return r.first.to_s.
              gsub('([^\\/?#]+)', ":#{r[1].first}").
              gsub('\\z)','').gsub('(?-mix:\\A', '').
              gsub('\\','')
          end
        end

        if path_uri.end_with?('.js')
          return '/js_asset'
        elsif path_uri.end_with?('.css')
          return '/css_asset'
        elsif path_uri.end_with?('.png', 'jpg')
          return '/css_asset'
        else
          return '/unknown' #path_uri
        end
      end
    end
  end
end

