# Mongoid Occurrence Views

Makes one's life easier when working with events that have multiple occurrences, or a recurring schedule. This gem helps to:

1. define multiple occurrences (or a recurring schedule) in a [Mongoid](https://github.com/mongodb/mongoid) document
2. expand these occurrences or a recurring schedule into series of daily events and embed them in the document
3. unwind the parent document into a [MongoDB view](https://docs.mongodb.com/manual/core/views) (think virtual collection defined by an aggregation) so that it becomes very easy to query against the parent documents using time-based criteria


## Requirements

* MongoDB 3.4+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid_occurrence_views'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_occurrence_views

## Usage

### Occurrences

Define a Mongoid document class that will hold information about each occurrence.

```ruby
class Occurrence
  include Mongoid::Document
  include MongoidOccurrenceViews::Occurrence

  embedded_in_event class_name: 'Event'
end
```

The following fields will become available:

* `dtstart`, (`DateTime`)
* `dtend` (`DateTime`)
* `all_day` (`Boolean`)
* `schedule` (`MongoidIceCubeExtension::Schedule`)

And the following scopes:

* `…`

### Events

```ruby
class Event
  include Mongoid::Document
  include MongoidOccurrenceViews::Event

  embeds_many_occurrences class_name: 'Occurrence'
end
```

The `embeds_many_occurences` macro will setup embedded relation that holds definition of occurrences. For example:

```ruby
<Occurrence dtstart: …, dtend: …, all_day: …, schedule: …>
<Occurrence dtstart: …, dtend: …, all_day: …, schedule: …>
<Occurrence dtstart: …, dtend: …, all_day: …, schedule: …>
```

Before each validation callback, each occurrence will expand its definition as follows:

* multi-day occurrences are split into single-day occurrences
* recurring schedules are expanded into single-day occurrences


### Views & queries

These previously expanded occurrences are then used for Mongoid aggregations.
The `embeds_many_occurrences` macro sets up two MongoDB views, based on the `Event` document collection name:

* `Event.occurrences_view_name` (`event__view`) that holds the `Event` documents with occurrences unwound as originally specified
* `Event.expanded_occurrences_view_name` (`event__expanded_view`) that hold `Event` documents with occurrences unwound per day

One can then use the ability of Mongoid to specify a collection to query against, like this:

```ruby
Event.with(collection: Event.occurrences_view_name) do
  Event.gte(dtstart: Time.zone.now).…
end
```

or

```ruby
Event.with(collection: Event.expanded_occurrences_view_name) do
  Event.gte(dtstart: Time.zone.now).…
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/mongoid_occurrence_views.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
