# Rack::Reqorder

Simple gem for monitoring Rack apps. Uses MongoDB. It can be used in combination
with [rack-reqorder-monitor](https://github.com/kollegorna/rack-reqorder-monitor).

## Introduction
Simple gem that sits on top of Rack and can:

- monitors for exceptions and provides full details, like where it happened as well as the request details
- record full requests/responses timelined, based on a header
- record request/response statistics

It saves everything in MongoDB and exposes simple API for retrieving these data.

The API is very robust, built with the help of [mongoid_hash_query](https://github.com/kollegorna/mongoid_hash_query).

A simple, default, dashboard is build in ember can be found [here](https://github.com/kollegorna/rack-reqorder-monitor).

At the moment, Rails, Sinatra and Grape are supported.
We are looking forward to add support for Hanami (ex-Lotus).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-reqorder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-reqorder

## Usage
You first need to initialize mongoid/mongodb by running:

```bash
bundle exec rails g mongoid:config
```

Then just add it on the middleware pipeline and initialize it.

For instance, in Rails, in an initializer add:

```ruby
Rack::Reqorder.configure do |config|
  config.mongoid_yml = File.join(Rails.root, 'config', 'mongoid.yml')
end

Rack::Reqorder.boot!

#if you run on development mode
Rails.application.config.middleware.insert_after(ActionDispatch::DebugExceptions , Rack::Reqorder::Logger)
#or if run on production
#Rails.application.config.middleware.insert_after(0, Rack::Reqorder::Logger)
```
Then in routes.rb enable the API for the [rack-reqorder-monitor](https://github.com/kollegorna/rack-reqorder-monitor).
```ruby
  require 'rack/reqorder/monitor'
  mount Rack::Reqorder::Monitor::Api => '/rack-reqorder'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/kollegorna/rack-reqorder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
