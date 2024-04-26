# frozen_string_literal: true

require "kafka"
require "json"
require "singleton"
require "forwardable"
# require "json/add/core"

module SSGMessageBus
  module Kafka
    class Producer
      include ::Singleton

      ATTRS = %i[seed_brokers client_id topic kafka_client kafka_producer].freeze
      attr_accessor(*ATTRS)

      class << self
        # just forward from class to singleton instance
        extend Forwardable
        def_delegators :instance,
                       :init, :raw_produce, :to_json_produce, :deliver_messages, :shutdown,
                       *ATTRS
      end

      def init(**kwargs)
        @topic          = kwargs[:topic]
        @client_id      = kwargs[:client_id]
        @seed_brokers   = kwargs[:seed_brokers]

        @kafka_client   = ::Kafka.new(@seed_brokers, client_id: @client_id)
        @kafka_producer = @kafka_client.producer
      end

      def raw_produce(raw_message, topic: @topic)
        producer.produce(raw_message, topic: topic)
      end

      def to_json_produce(obj_message, topic: @topic)
        produce_raw(JSON.dump(obj_message), topic: topic)
      end

      def deliver_messages
        @producer.deliver_messages
      end

      def shutdown
        @producer.shutdown
      end
    end
  end
end
