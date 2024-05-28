# # # frozen_string_literal: true

require_relative "../../lib/ssg_message_bus"
require_relative "../config"

consumer = SSGMessageBus::GCPPubSub::Consumer.new(
  emulator_host:  ENV_MESSAGE_BUS_EMULATOR_HOST,
  project_id:     ENV_MESSAGE_BUS_PROJECT_ID,
  topics:         ['ping'],
)

consumer.on_topic_message('ping') do |message|
  puts "consumer.on_topic_message('ping')"
  puts "#on_topic_on_message hook is treggered on topic: ping message:", message.inspect
  puts 'attributes:', message.attributes
  puts 'data:', message.data
  puts 'attributes:', message.message.attributes
  puts 'data:', message.message.data
end

consumer.start

sleep