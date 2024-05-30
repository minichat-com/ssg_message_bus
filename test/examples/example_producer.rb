# frozen_string_literal: true

require_relative "../../lib/ssg_message_bus"
require_relative "../config"

producer = SSGMessageBus::GCPPubSub::Producer.new(
  emulator_host:  ENV_MESSAGE_BUS_EMULATOR_HOST,
  project_id:     ENV_MESSAGE_BUS_PROJECT_ID,
  topics:         ['ping']
)

producer.publish(topic: 'ping', data: 42, source: 'example-source', destination: 'example-destination')
producer.publish(topic: 'ping', data: 42, source: 'example-source', destination: 'filtered-destination')
producer.publish(topic: 'ping', data: 42, source: 'unset-source', destination: 'filtered-destination')