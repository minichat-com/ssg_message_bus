# frozen_string_literal: true

require "kafka"
require "json"
# require 'json/add/core'

module SSGMessageBus
  module Kafka
    class Consumer
      attr_accessor :seed_brokers,
                    :client_id,
                    :topic,
                    :kafka_client,
                    :consumer_group_id,
                    :thread

      def initialize(**kwargs)
        @client_id          = kwargs[:client_id]
        @consumer_group_id  = kwargs[:consumer_group_id]
        @seed_brokers       = kwargs[:seed_brokers]
        @topic              = kwargs[:topic]

        @kafka_client       = ::Kafka.new(@seed_brokers, client_id: @client_id)
        @kafka_consumer     = @kafka_client.consumer(group_id: @consumer_group_id)
      end

      def invoke_handler_for(event); end

      def preprocess_raw_message(kafka_message)
        parsed_data = nil
        parsing_error = nil
        begin
          parsed_data = JSON.parse(kafka_message.value)
        rescue StandardError => e
          parsing_error = e
        end
        preprocessed_message = {
          metadata: {
            kafka: {
              topic: kafka_message.topic,
              partition: kafka_message.partition,
              offset: kafka_message.offset,
              key: kafka_message.key,
              value: kafka_message.value
            },
            consumer: {}
          },
          data: parsed_data
        }
        preprocessed_message[:metadata][:consumer][:error] = parsing_error if parsing_error

        preprocessed_message
      end

      def construct_domain_event_from(preprocessed_message); end

      def subscribe(topic = @topic, start_from_beginning: false)
        kafka_consumer.subscribe(topic, start_from_beginning: start_from_beginning)
      end

      def run
        @thread = Thread.new do
          trap("TERM") do
            term
          end

          kafka_consumer.each_message do |message|
            process_raw_message(message)
              .then { |hash| construct_domain_event_from(hash) }
              .then { |event| invoke_handler_for(event) }

            # we can set the checkpoint by marking the last message as processed.
            kafka_consumer
              .mark_message_as_processed(message)

            # We can optionally trigger an immediate, blocking offset commit in order
            # to minimize the risk of crashing before the automatic triggers have
            # kicked in.
            kafka_consumer.commit_offsets
          end
        end
      end

      def term
        kafka_consumer.commit_offsets
        kafka_consumer.stop
      end

      def stop
        term
        thread.stop
      end
    end
  end
end
