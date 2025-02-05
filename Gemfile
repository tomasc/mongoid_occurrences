source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in mongoid_occurrences.gemspec
gemspec

gem 'concurrent-ruby', '1.3.4'

case version = ENV.fetch('MONGOID_VERSION', '~> 8.0')
when /8/ then gem 'mongoid', '~> 8.0'
when /7/ then gem 'mongoid', '~> 7.0'
else gem 'mongoid', version
end
