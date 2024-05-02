# # # frozen_string_literal: true

require_relative "../../lib/ssg_message_bus"
require_relative "../config"

consumer = SSGMessageBus::GCPPubSub::Consumer.new(
  emulator_host:  ENV_MESSAGE_BUS_EMULATOR_HOST,
  project_id:     ENV_MESSAGE_BUS_PROJECT_ID,
  topic:          ENV_MESSAGE_BUS_TOPIC,
  subscription:   ENV_MESSAGE_BUS_SUBSCRIPTION
)

consumer.start

consumer.on_message do |msg|
  puts "#on_message hook is treggered by message", msg.inspect
  puts 'Event type:', msg.attributes['event_type']
end


sleep