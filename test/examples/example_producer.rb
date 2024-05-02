# frozen_string_literal: true

require_relative "../../lib/ssg_message_bus"
require_relative "../config"

PROJECT = 'the-project'
TOPIC = 'the-topic'
SUBSCRIPTION = 'the-topic-sub'


producer = SSGMessageBus::GCPPubSub::Producer.new(
  emulator_host:  '[::1]:8092',
  project_id:     PROJECT,
  topic:          TOPIC
)

producer.publish({ event_type: "ping" })
