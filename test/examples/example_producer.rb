# frozen_string_literal: true

require_relative "../../lib/ssg_message_bus"
require_relative "../config"

producer = SSGMessageBus::GCPPubSub::Producer.new(
  emulator_host:  ENV_MESSAGE_BUS_EMULATOR_HOST,
  project_id:     ENV_MESSAGE_BUS_PROJECT_ID,
  topic:          ENV_MESSAGE_BUS_TOPIC
)

producer.publish({ event_type: "ping" })
