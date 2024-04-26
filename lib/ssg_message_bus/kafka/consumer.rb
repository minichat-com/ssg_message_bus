# frozen_string_literal: true

require "forwardable"
require "json"
require "kafka"
require "singleton"

module SSGMessageBus
  module Kafka
    class Consumer
      include ::Singleton
      ATTRS = %i[seed_brokers
                 client_id
                 topic
                 kafka_client
                 kafka_consumer

                 process_data_block

                 consumer_group_id
                 thread].freeze
      attr_accessor(*ATTRS)

      class << self
        # just forward from class to singleton instance
        extend Forwardable
        def_delegators :instance,
                       :init, :run, :stop, :subscribe, :process_data,
                       *ATTRS
      end

      def init(**kwargs)
        @client_id          = kwargs[:client_id]
        @consumer_group_id  = kwargs[:consumer_group_id]
        @seed_brokers       = kwargs[:seed_brokers]
        @topic              = kwargs[:topic]

        @kafka_client       = ::Kafka.new(@seed_brokers, client_id: @client_id)
        @kafka_consumer     = @kafka_client.consumer(group_id: @consumer_group_id)
      end

      def process_data(&block)
        @process_data_block = block
      end

      def invoke_data_processor(data)
        return unless process_data_block

        process_data_block.call(data)

        # we can set the checkpoint by marking the last message as processed.
        kafka_consumer.mark_message_as_processed(message)

        # We can optionally trigger an immediate, blocking offset commit in order
        # to minimize the risk of crashing before the automatic triggers have
        # kicked in.
        kafka_consumer.commit_offsets
      end

      def extract_data(kafka_message)
        parsed_data = {}
        parsing_error = nil
        begin
          parsed_data = JSON.parse(kafka_message.value)
        rescue StandardError => e
          parsing_error = e
        end
        metadata = {
          metadata: {
            kafka: {
              create_time:      kafka_message.create_time,
              topic:            kafka_message.topic,
              partition:        kafka_message.partition,
              offset:           kafka_message.offset,

              key:              kafka_message.key,
              value:            kafka_message.value
            },
            consumer: {}
          }
        }
        metadata[:consumer][:error] = parsing_error if parsing_error

        metadata.merge(parsed_data)
      end

      def subscribe(topic = @topic, start_from_beginning: false)
        kafka_consumer.subscribe(topic, start_from_beginning: start_from_beginning)
      end

      def run
        trap("TERM") do
          term
        end

        kafka_consumer.each_message do |message|
          extract_data(message)
            .then { |data| invoke_data_processor(data) }
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
