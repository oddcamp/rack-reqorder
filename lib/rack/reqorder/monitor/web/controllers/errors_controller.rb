module Rack::Reqorder::Monitor::Web::Controllers
  class Errors < P::Base
    def resolve
      app_faults = M::AppFault.all.order_by(updated_at: :desc).to_a

      return super({faults: app_faults})
    end
  end

  class Error < P::Base
    def resolve
      return super({
        fault: app_fault, exception: exception,
        previous_exception: previous_exception,
        next_exception: next_exception
      })
    end

    private
      def exception
        M::AppException.find(exception_id)
      end

      def previous_exception
        return nil if exception_ids.index(exception_id) - 1 < 0
        id = exception_ids[exception_ids.index(exception_id) - 1]
        return nil if id.nil?

        OpenStruct.new({
          id: id,
          path: "/errors/#{app_fault.id}?exception_id=#{id}"
        })
      end

      def next_exception
        return nil if exception_ids.index(exception_id) + 1 > exception_ids.length
        id = exception_ids[exception_ids.index(exception_id) + 1]
        return nil if id.nil?

        OpenStruct.new({
          id: id,
          path: "/errors/#{app_fault.id}?exception_id=#{id}"
        })
      end

      def exception_ids
        @exception_ids ||= app_fault.app_exceptions.order_by(
          created_at: :asc
        ).pluck(:id).map(&:to_s)
      end

      def exception_id
        @exception_id ||= begin
          if params['exception_id']
            params['exception_id']
          else
            exception_ids.last
          end
        end
      end

      def app_fault
        @app_fault ||= M::AppFault.find(params['id'])
      end
  end
end
