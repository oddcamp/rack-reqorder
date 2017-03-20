class Rack::Reqorder::Monitor::Web::EntityDecorator
  def self.for_collection(collection, entity)
    collection.map do |object|
      self.new(object, entity)
    end
  end
  def initialize(object, entity)
    entity.root_exposures.map(&:key).each do |key|
      define_singleton_method(key) do
        entity.new(object).value_for(key)
      end
    end
  end
end
