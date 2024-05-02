# # # frozen_string_literal: true

# # require_relative "../../lib/ssg_message_bus"
# # require_relative "../config"

# # SSGMessageBus::GCPPubSub::Consumer.init(
# #   emulator_host:     '[::1]:8772',
# #   project_id:        'example-project-id',
# #   client_id:         ENV_KAFKA_CLIENT_ID,
# #   consumer_group_id: ENV_KAFKA_CONSUMER_GROUP_ID,
# #   seed_brokers:      ENV_KAFKA_SEED_BROKERS,
# #   topic:             ENV_KAFKA_TOPIC
# # )

# # # SSGMessageBus::GCPPubSub::Consumer.subscribe

# # # SSGMessageBus::GCPPubSub::Consumer.process_data do |data|
# # #   puts "process_data", data.inspect
# # # end

# # SSGMessageBus::GCPPubSub::Consumer.run

# # loop { sleep 0.1 }

# PROJECT = 'the-project'
# TOPIC = 'the-topic'
# SUBSCRIPTION = 'the-topic-sub'

# require "google/cloud/pubsub"

# pubsub = Google::Cloud::PubSub.new(
#   project_id:     PROJECT,
#   emulator_host:  '[::1]:8850',
# )

# # Retrieve a topic
# # topic = pubsub.create_topic "greetings"
# topic_instance =  unless (topic_instance = pubsub.topic TOPIC)
#                     pubsub.create_topic TOPIC
#                     pubsub.topic TOPIC
#                   else
#                     topic_instance
#                   end

# # Publish a new message
# msg = topic_instance.publish "new-message"

# # create subscription
# # topic.subscribe "greetings-sub"

# # Retrieve a subscription
# subscription_instance = unless (subscription_instance = pubsub.subscription SUBSCRIPTION)
#                           topic_instance.subscribe SUBSCRIPTION
#                           pubsub.subscription SUBSCRIPTION
#                         else
#                           pubsub.subscription SUBSCRIPTION
#                         end

# # Create a subscriber to listen for available messages
# # By default, this block will be called on 8 concurrent threads.
# # This can be changed with the :threads option
# subscriber = subscription_instance.listen do |received_message|
#   # process message
#   puts "Data: #{received_message.message.data}, published at #{received_message.message.published_at}"
#   puts received_message.inspect
#   received_message.acknowledge!
# end

# # Handle exceptions from listener
# subscriber.on_error do |exception|
#   puts "Exception: #{exception.class} #{exception.message}"
# end

# # Gracefully shut down the subscriber on program exit, blocking until
# # all received messages have been processed or 10 seconds have passed
# at_exit do
#     subscriber.stop!(10)
# end

# # Start background threads that will call the block passed to listen.
# subscriber.start

# # Block, letting processing threads continue in the background
# sleep

require_relative "../../lib/ssg_message_bus"

consumer = SSGMessageBus::GCPPubSub::Consumer.new(
  credentials: nil,
  emulator_host: '[::1]:8092',

  project_id:   'the-project',
  topic:        'the-topic',
  subscription: 'the-subscription'
)

consumer.start

consumer.on_message do |msg|
  puts "#on_message hook is treggered by message", msg.inspect
  puts 'Event type:', msg.attributes['event_type']
end


sleep