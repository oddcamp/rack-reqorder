# Rack::Reqorder
Simple gem for monitoring Rack apps. Uses MongoDB underneath.

Intended to be used mostly on development and staging environments, mostly for APIs.

## Introduction
Simple gem that sits on top of Rack and:

- monitors for exceptions and provides full details, like where it happened as well as the request details
- records full requests/responses timelined, based on a header/header value
- records request/response statistics

Each functionality can be enabled/disabled by the embedded dashboard.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-reqorder'
```

And then execute:
```
bundle install
```

**For Rails 5.x you need to add Sinatra 2.x in your Gemfile to use the dashboard**

```ruby
  gem "sinatra", ">= 2.0.0.rc1"
```


## Usage
If you don't already have Mongoid in your app, you first need to initialize it by running:

```bash
bundle exec rails g mongoid:config
```

**Then** just add `rack-reqorder` in the middleware pipeline and initialize it.

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
Then in routes.rb enable the little dashboard:
```ruby
  mount Rack::Reqorder::Monitor::Web::Application => '/rack-reqorder'
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
