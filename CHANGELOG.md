# CHANGELOG

## 1.2.0

- ADD: mongoid 8 compatibility

## 1.1.6

- FIX: `dtstart` / `dtend` blowing up when `daily_occurrences` are nil

## 1.1.5

- FIX: wiping `#daily_occurrences` when removing all `#occurrences`
- FIX: correctly assign `#daily_occurrences` when changing `#occurrences`

## 1.1.4

- ADD: default sort order on the `#occurrences` association

## 1.1.2

- FIX: missing minutes when creating daily occurrences from a schedule

## 1.1.1

- FIX: issues with handling time zone in daily occurrences and queries
- ADD: validation on `Occurrence` for `dtend` being after `dtstart`

## 1.1.0

- CHANGE: `#embedded_in_event` requires `name` (`#embedded_in_event(name, options)`)

## 1.0.4

- FIX: We rely on occurrences having their `updated_at` field touched when saving an event, which currently doesn't happen. Adding `cascade_callbacks` fixes that.

## 1.0.3

- ADD: allow to specify `:parent_name` on `.embedded_in_event` macro

## 1.0.2

- ADD: `DailyOccurrence` has now `oid (occurrence_id)` referring to the original occurrence

## 1.0.1

- FIX: spelling of `*occurrences_cache_key*` related methods

## 1.0.0

- REFACTOR: [PR#4](https://github.com/tomasc/mongoid_occurrences/pull/4) Refactor to replace views with aggregations

## 0.2.0

- [PR#3](https://github.com/tomasc/mongoid_occurrences/pull/3) `all_day` becomes a field

## 0.1.1

- [PR#2](https://github.com/tomasc/mongoid_occurrences/pull/2) allow :assign_daily_occurrences to be triggerred manually

## 0.1.0

- initial release
