# SSGMessageBus

With **SSGMessageBus** you may interact send and receive messages over **Google PubSub**.
It is a thin wrapper, which enforces "create resource unless found", "deliver once"  and message acknowlegement.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ssg_message_bus'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ssg_message_bus

## Initialization & Usage

### Producer
```ruby
require "ssg_message_bus"

producer = SSGMessageBus::GCPPubSub::Producer.new(
  emulator_host:  '[::1]:8092', # only for emulator
  credentials:    ENV.fetch('MESSAGE_BUS_CREDENTIALS_PATH'), # only for non-emulator
  
  project_id:     ENV.fetch('MESSAGE_BUS_PROJECT_ID'),
  topic:          ENV.fetch('MESSAGE_BUS_TOPIC')
)

producer.publish(
  topic: "ping", 
  data: 42, 
  source: "example-source", 
  destination: "example-destination"
)

producer.publish(
  topic: "ping", 
  data: {
    key_one: [:array, 'of', 1],
    key_two: Time.current
        }.to_json, 
  source: "example-source", 
  destination: "example-destination"
)
```

### Consumer
```ruby
require "ssg_message_bus"

consumer = SSGMessageBus::GCPPubSub::Consumer.new(
  emulator_host:  '[::1]:8092', # only for emulator
  credentials:    ENV.fetch('MESSAGE_BUS_CREDENTIALS_PATH'), # only for non-emulator

  project_id:     ENV.fetch('MESSAGE_BUS_PROJECT_ID'),
  topic:          ENV.fetch('MESSAGE_BUS_TOPIC'),
  subscription:   ENV.fetch('MESSAGE_BUS_SUBSCRIPTION'),
)

consumer.start

# define consumption behavior
consumer.on_topic_message("ping") do |message|
  puts "attributes:", message.attributes.inspect
  puts "data:", message.data.inspect
end
```

## Development
See `test/config.rb` for example settings used in tests.

In your shell launch Google Pub Sub emulator:

Alpha version of the emulator:
```
gcloud alpha emulators pubsub start --project=[PROJECT_ID] --host-port=[EMULATOR_HOST]
```

Beta version of the emulator:
```
gcloud beta emulators pubsub start --project=[PROJECT_ID] --host-port=[EMULATOR_HOST]
```

Recommended defaults are:
```
gcloud beta emulators pubsub start --project=message-bus-example-project --host-port=0.0.0.0:8085
```

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/minichat-com/ssg_message_bus.
