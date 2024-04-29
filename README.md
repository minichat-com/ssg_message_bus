# SSGMessageBus

With **SSGMessageBus** you may interact with raw **Kafka** messages, or with abstraction of **Events**.

**Events** abstract away details of **Kafka** messaging, and create domain-specific interface for *event emission* (message production, publishing) and *event handling* (message consumption, subscription).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ssg_message_bus'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ssg_message_bus

## Initialization

### Producer
```ruby
SSGMessageBus::Kafka::Producer.init(
  client_id:    ENV_KAFKA_CLIENT_ID,
  seed_brokers: ENV_KAFKA_SEED_BROKERS,
  topic:        ENV_KAFKA_TOPIC
)
```

### Consumer
```ruby
SSGMessageBus::Kafka::Consumer.init(
  client_id:         ENV_KAFKA_CLIENT_ID,
  consumer_group_id: ENV_KAFKA_CONSUMER_GROUP_ID,
  seed_brokers:      ENV_KAFKA_SEED_BROKERS,
  topic:             ENV_KAFKA_TOPIC
)

# when system is initialized, and ready to process events
SSGMessageBus::Kafka::Consumer.run
  
# when system is exiting
SSGMessageBus::Kafka::Consumer.stop
```

## Usage
### Producer
Deliver data:
```ruby
# As long as Producer is configured, 
# event#emit would construct message
# and would trigger it's delivery
SSGMessageBus::Kafka::Producer.deliver_data({ event_type: "ping" })
```


### Consumer
Process data:
```ruby
# As long as Consumer is configured, 
# incoming message would be reconstructed into 
# data, processsable in
# handling block
SSGMessageBus::Kafka::Consumer.process_data do |data|
  puts 'process_data', data.inspect
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/minichat-com/ssg_message_bus.
