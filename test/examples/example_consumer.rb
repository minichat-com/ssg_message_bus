# frozen_string_literal: true

# # # frozen_string_literal: true

require_relative "../../lib/ssg_message_bus"
require_relative "../config"

consumer = SSGMessageBus::GCPPubSub::Consumer.new(
  emulator_host:  ENV_MESSAGE_BUS_EMULATOR_HOST,
  project_id:     ENV_MESSAGE_BUS_PROJECT_ID,
  topics:         ["ping"],
  destination:    "filtered-destination"
)

consumer.on_topic_message("ping") do |message|
  puts "attributes:", message.attributes.inspect
  puts "data:", message.data.inspect
end

consumer.start

sleep
