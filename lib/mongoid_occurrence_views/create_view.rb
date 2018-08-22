module MongoidOccurrenceViews
  class CreateView < Struct.new(:view_name, :view_on, :pipeline)
    def self.call(*args)
      new(*args).call
    end

    def call
      Mongoid.clients.each do |name, _|
        client = Mongoid.client(name)
        next if client.collections.map(&:name).include?(view_name)
        client.command(create: view_name, viewOn: view_on, pipeline: pipeline)
      end
    end
  end
end
