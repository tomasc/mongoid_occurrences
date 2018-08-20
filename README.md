# Mongoid Occurrence Views

An approach to dealing with events in [mongoid](https://github.com/mongodb/mongoid) using IceCube for schedules and [MongoDB views](https://docs.mongodb.com/manual/core/views) for querying.

Your model (say `Event`) embeds a list of occurrences. Each occurrence has a start time, an end time, and an optional schedule (for defining recurrence). When a schedule is defined, the occurrence is automatically "expanded" into a list of daily occurrences upon saving. This setup allows for a great deal of flexibility.

The gem provides automatic aggregations which project the events into MongoDB views that can be subsequently queried, for either the original, or the expanded occurrences. This means that by using the view you can query `Event`s by their occurrences, say all `Event`s for Monday Aug 20.

<!-- A list of occurrences (embedded in a Mongoid Document, each defined by datetime from & datetime to) is expanded (typically on save) into a list of daily occurrences. Two aggregations project the events into Mongodb views (3.4+) that can be subsequently queried – both for the original, or the expanded occurrences. -->

<!-- Use [MongoDB views](https://docs.mongodb.com/manual/core/views) for querying events with multiple occurrences. -->

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

```ruby
class Event
  include Mongoid::Document
  include MongoidOccurrenceViews::HasOccurrences
  has_occurrences
end
```

This defines an embedded `:occurrences` relation on `Event`.

### Occurrences

The occurrence model (`MongoidOccurrenceViews::Occurrence`) holds logic about it's own duration and recurrence.
It has the following fields:
* `dtstart`, (`DateTime`)
* `dtend` (`DateTime`)
* `all_day` (`Boolean`)
* `schedule` (`MongoidIceCubeExtension::Schedule`)

### Querying

```ruby
Event.with_occurrences_view do
```

```ruby
EventPage.with_expanded_occurrences_view do
  = EventPage.criteria.…
end
```

### Configuration

### Views

In case you like to create the MongoDB views manually, you can their automatic
creation:

`has_occurrences create_views: false`

and then define them in for instance an initializer:

```ruby
# config/initializers/mongoid_occurrence_views.rb

Mongoid::CreateView.call(
  Event::EXPANDED_VIEW_NAME,
  Event.collection.name,
  [
    { '$match': { '_type': EventPage.to_s } },
    { '$addFields': { '_expanded_occurrences': '$expanded_occurrences' } },
    { '$unwind': '$_expanded_occurrences' },
    { '$addFields': {
        '_dtstart': '$_expanded_occurrences.dtstart',
        '_dtend': '$_expanded_occurrences.dtend',
        '_all_day': '$_expanded_occurrences.all_day',
        '_sort_key': '$_expanded_occurrences.dtstart'
      }
    }
  ]
)
```

#### Occurrence class

It's possible to specify which model to use:

`has_occurrences occurrence_class_name: 'MyOccurrence'`

This is helpful in the cases where you would like to extend, change, or override
the default behavior of the `MongoidOccurrenceViews::Occurrence` model.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/mongoid_occurrence_views.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).