#Heavy influenced by ActionDispatch::DebugExceptions

module Rack::Reqorder::Models
  class AppException
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :e_class, type: String
    field :message, type: String
    field :application_trace, type: Array
    #field :framework_trace, type: Array
    field :full_trace, type: Array
    field :line, type: Integer
    field :filepath, type: String
    field :source_extract, type: Hash

    belongs_to :http_request, {dependent: :nullify}.merge(REQUIRED)
    belongs_to :app_fault, {dependent: :nullify}.merge(REQUIRED)

    after_save :update_count

  private
    def update_count
      self.app_fault.update_count!
    end
  end
end
