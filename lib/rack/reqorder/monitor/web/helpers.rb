module Rack::Reqorder::Monitor::Web::Helpers
  module ViewHelpers
    def pre_source_extract(hash)
      str = ''
      return str unless hash

      hash.each do |k, v|
        str += "#{k}.#{v.gsub("\n", "<br>")}"
      end

      return str
    end

    def format_trace(trace)
      trace.join("<br>")
    end

    def active?(route = nil)
      if route.nil?
        if request.path_info == '/'
          return 'active' 
        end
      else
        return 'active' if request.path_info.include?(route.to_s)
      end
    end

    def truthy_param(param)
      return false if ['0', 'false', 'f', false].include?(param.to_s.downcase)

      return true
    end

    def pathy(path)
      request.base_url + request.script_name + path
    end
  end
end
