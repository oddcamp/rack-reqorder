module Rack::Reqorder::Monitor::Web::Controllers
  class Recordings < P::Base
    def resolve
      recordings = M::Recording.all.order_by(updated_at: :desc).to_a

      return super({recordings: recordings})
    end
  end

  class Recording < P::Base
    def resolve
      recording = M::Recording.find(params[:id])

      return super({recording: recording})
    end
  end
end
