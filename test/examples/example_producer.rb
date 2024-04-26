# frozen_string_literal: true

require "ssg_message_bus"
require_relative "../config"

SSGMessageBus::Kafka::Producer.init(
  client_id:    ENV_KAFKA_CLIENT_ID,
  seed_brokers: ENV_KAFKA_SEED_BROKERS,
  topic:        ENV_KAFKA_TOPIC
)

SSGMessageBus::Kafka::Producer.deliver_data({ event_type: "ping" })
