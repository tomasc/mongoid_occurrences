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
        next unless client.collections.map(&:name).include?(name)
        client.command(drop: name)
      end
    end

    private

    attr_reader :name
  end
end
