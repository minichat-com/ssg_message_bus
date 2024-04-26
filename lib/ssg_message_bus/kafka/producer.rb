# frozen_string_literal: true

require "forwardable"
require "json"
require "kafka"
require "singleton"

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
                       :init, :raw_produce, :to_json_produce, :deliver_data, :deliver_messages, :shutdown,
                       *ATTRS
      end

      def init(**kwargs)
        @topic          = kwargs[:topic]
        @client_id      = kwargs[:client_id]
        @seed_brokers   = kwargs[:seed_brokers]

        @kafka_client   = ::Kafka.new(@seed_brokers, client_id: @client_id)
        @kafka_producer = @kafka_client.producer
      end

      def deliver_data(data, topic: @topic)
        kafka_producer.produce(JSON.dump(data), topic: topic)
        kafka_producer.deliver_messages
      end

      def deliver_messages
        kafka_producer.deliver_messages
      end

      def shutdown
        kafka_producer.shutdown
      end
    end
  end
end
