# frozen_string_literal: true

require_relative "ssg_message_bus/version"
require_relative "ssg_message_bus/events"
require_relative "ssg_message_bus/kafka/producer"
require_relative "ssg_message_bus/kafka/consumer"

module SSGMessageBus
  class Error < StandardError; end

  SOURCES = %w[videochat-admin minichat chatruletka sn-stage].freeze

  class << self
    def init(&block); end

    def event_from_message(raw_message); end

    def message_from_event(event); end
  end

  # kafka-specific stuff: topic, partition

  # created_at: '',
  # event_type: EventType,
  # from: Source,
  # to: Source,
  # payload: { … },
  # meta: { ? }

  # domain-specific event objects, constructed out of messages
  # raw_message
  # metadata = { kafka: ; raw_message: ; ssg: ; producer: ; consumer: ; }
  # MyEvent.emit(**attributes)

  # MyEvent.handle do |e|
  # end
end