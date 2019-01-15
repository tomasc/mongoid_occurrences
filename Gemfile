source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in mongoid_occurrences.gemspec
gemspec

case version = ENV['MONGOID_VERSION'] || '~> 7.0'
when /7/ then gem 'mongoid', '~> 7.0'
else gem 'mongoid', version
end
