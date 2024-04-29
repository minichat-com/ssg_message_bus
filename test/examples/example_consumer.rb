# frozen_string_literal: true

require_relative "../../lib/ssg_message_bus"
require_relative "../config"

SSGMessageBus::Kafka::Consumer.init(
  client_id:         ENV_KAFKA_CLIENT_ID,
  consumer_group_id: ENV_KAFKA_CONSUMER_GROUP_ID,
  seed_brokers:      ENV_KAFKA_SEED_BROKERS,
  topic:             ENV_KAFKA_TOPIC
)

SSGMessageBus::Kafka::Consumer.subscribe

SSGMessageBus::Kafka::Consumer.process_data do |data|
  puts "process_data", data.inspect
end

SSGMessageBus::Kafka::Consumer.run

loop { sleep 0.1 }
