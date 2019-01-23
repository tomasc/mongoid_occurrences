# Mongoid Occurrences

[![Build Status](https://travis-ci.org/tomasc/mongoid_occurrences.svg)](https://travis-ci.org/tomasc/mongoid_occurrences) [![Gem Version](https://badge.fury.io/rb/mongoid_occurrences.svg)](http://badge.fury.io/rb/mongoid_occurrences) [![Coverage Status](https://img.shields.io/coveralls/tomasc/mongoid_occurrences.svg)](https://coveralls.io/r/tomasc/mongoid_occurrences)

Facilitates aggregations for events with multiple occurrences or a recurring schedule.

## Requirements

* Mongoid 7+
* MongoDB 3.4+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid_occurrences'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_occurrences

## Usage

### Event

Define a Mongoid document that will embed occurrence definitions.

```ruby
class Event
  include Mongoid::Document
  include MongoidOccurrences::HasOccurrences

  embeds_many_occurrences class_name: "Occurrence"
end
```

This document will gain the `#assign_daily_occurrences!` method (automatically triggered `:after_validation`), which expands all occurrence definitions in the embedded relation called `#daily_occurrences`.

The class will also gain the following scopes, useful for querying for events based on the `#daily_occurrences`:

* `.occurs_between(dtstart, dtend)`
* `.occurs_from(dtstart)`
* `.occurs_on(day)`
* `.occurs_until(dtend)`

### Occurrence

Define a Mongoid document that defines the occurrence.

```ruby
class Occurrence
  include Mongoid::Document
  include MongoidOccurrences::Occurrence

  embedded_in_event :event, class_name: 'Event'
end
```

This document will gain the `#dtstart`, `#dtend` and `#all_day` fields to define individual occurrences.

Recurring schedule is handled via the [IceCube](https://github.com/seejohnrun/ice_cube) and [MongoidIceCubeExtension](https://github.com/tomasc/mongoid_ice_cube_extension) gems. The model gains `#schedule`, and `#schedule_dtstart`, `#schedule_dtend` fields (with default values for schedule 1 year from now), along with `#recurrence_rule=` writer method.

It is possible to influence the way the occurrences are expanded into `#daily_occurrences` using the `#operator` enum field, which accepts the following values:

* `:append` – appends to the list of `#daily_occurrences` (default)
* `:replace` – replaces all occurrences that happen on the same day with itself
* `:remove` - removes all occurrences that happen on the same day

### Indexes

To optimize the performance of the above scope queries, you might want to add the following indexes:

```ruby
index :'daily_occurrences.ds' => 1
index :'daily_occurrences.de' => 1
```

### Aggregations

It is possible to aggregate (unwind) the events so that they are multiplied per daily occurrences. Example aggregations are included:

* `MongoidOccurrences::Aggregations::OccursBetween.instantiate(Event.criteria, dtstart, dtend)`
* `MongoidOccurrences::Aggregations::OccursFrom.instantiate(Event.criteria, dtstart)`
* `MongoidOccurrences::Aggregations::OccursOn.instantiate(Event.criteria, day)`
* `MongoidOccurrences::Aggregations::OccursUntil.instantiate(Event.criteria, dtend)`

The aggregations will add `#_dtstart`, `#_dtend` fields to the unwound documents. For easier access, mixin the `MongoidOccurrences::HasFieldsFromAggregation` to your `Event` class:

```ruby
class Event
  include Mongoid::Document
  include MongoidOccurrences::HasFieldsFromAggregation
  include MongoidOccurrences::HasOccurrences

  embeds_many_occurrences class_name: "Occurrence"
end
```

This will automatically add `#dtstart` and `#dtend` fields with correct (demongoized) values, as well as the `#all_day?` method.

### Embedded events

If your events are itself embedded:

```ruby
class EventParent
  embeds_many :events, class_name: 'Event'
end
```

Simply add the following scopes on the parent document:

```ruby
class EventParent
  scope :occurs_between, ->(dtstart, dtend) { elem_match(events: Event.occurs_between(dtstart, dtend).selector) }
  scope :occurs_from, ->(date_time) { elem_match(events: Event.occurs_from(date_time).selector) }
  scope :occurs_on, ->(date_time) { elem_match(events: Event.occurs_on(date_time).selector) }
  scope :occurs_until, ->(date_time) { elem_match(events: Event.occurs_until(date_time).selector) }

  include MongoidOccurrences::HasFieldsFromAggregation

  delegate :daily_occurrences, to: :event
end
```

You will then need to write your own aggregations with an extra step to `$unwind` the embedded `#events`, and your indexes will need to be adjusted as follows:

```ruby
index :'events.daily_occurrences.ds' => 1
index :'events.daily_occurrences.de' => 1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/mongoid_occurrences.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
