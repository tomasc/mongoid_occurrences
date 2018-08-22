module MongoidOccurrenceViews
  class DestroyView
    def initialize(name:)
      @name = name
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      Mongoid.clients.each do |client_name, _|
        client = Mongoid.client(client_name)
        next if client.collections.map(&:name).include?(name)
        client.command(destroy: name)
      end
    end

    private

    attr_reader :name
  end
end
