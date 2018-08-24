module MongoidOccurrenceViews
  class CreateMongoidView
    def initialize(name:, collection:, pipeline:)
      @name = name
      @collection = collection
      @pipeline = pipeline
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      Mongoid.clients.each do |client_name, _|
        client = Mongoid.client(client_name)
        next if client.collections.map(&:name).include?(name)
        client.command(create: name, viewOn: collection, pipeline: pipeline)
      end
    end

    private

    attr_reader :name, :collection, :pipeline
  end
end
