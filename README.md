# Mongoid Occurrence Views

Makes one's life easier when working with events that have multiple occurrences, or a recurring schedule. This gem creates a virtual [Mongodb view](https://docs.mongodb.com/manual/core/views) containing parent documents (events) for each day in which it occurs.

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
  include MongoidOccurrenceViews::Event::Occurrence

  embedded_in_event class_name: 'Event'
end
```

The following fields will become available:

* `dtstart`, (`DateTime`)
* `dtend` (`DateTime`)
* `schedule` (`MongoidIceCubeExtension::Schedule`)

* `all_day` (`Boolean`)

### Events

```ruby
class Event
  include Mongoid::Document
  include MongoidOccurrenceViews::Event

  embeds_many_occurrences class_name: 'Occurrence'
end
```

The `embeds_many_occurences` macro will setup an embedded relation that holds a definition of occurrences. For example:

```ruby
<Occurrence dtstart: …, dtend: …, schedule: …>
<Occurrence dtstart: …, dtend: …, schedule: …>
<Occurrence dtstart: …, dtend: …, schedule: …>
```

Before each validation callback, each occurrence will expand its definition as follows:

* multi-day occurrences are split into single-day occurrences
* recurring schedules are expanded into single-day occurrences

The following scopes are available for querying:

* `for_date_time(DateTime)`
* `for_date_time_range(DateTime, DateTime)`
* `from_date_time(DateTime)`
* `to_date_time(DateTime)`

And these scopes for ordering:

* `order_by_start(:asc / :desc)`
* `order_by_end(:asc / :desc)`

Note: while these will work outside the supplied views, you can't be sure of their results!

### Views & queries

The `Event.expanded_occurrences_view_name` is simply a wrapper on default Mongoid's `.with(collection: …)`, specifying the collection to be the expanded virtual one (`event__expanded_occurrences_view`).

```ruby
Event.with_expanded_occurrences_view do
  Event.from_date_time(Time.zone.now).…
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/mongoid_occurrence_views.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
