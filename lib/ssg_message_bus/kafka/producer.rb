# frozen_string_literal: true

require "kafka"
require "json"
# require 'json/add/core'

module SSGMessageBus
  module Kafka
    class Producer
      KAFKA_SEED_BROKERS = ["127.0.0.1:9092", "localhost:9092"].freeze
      KAFKA_CLIENT_ID = "kafka-client-id"
      KAFKA_CONSUMER_GROUP_ID = "test-consumer-group"
      KAFKA_TOPIC = "greetings"

      attr_accessor :seed_brokers, :client_id, :topic, :kafka_client, :kafka_producer

      def initialize(**kwargs)
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
