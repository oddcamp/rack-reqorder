module Rack::Reqorder::Monitor::Web::Controllers
  class Request < P::Base
    def resolve
      request = M::HttpRequest.find(params[:id])

      return super({request: request})
    end
  end
end
