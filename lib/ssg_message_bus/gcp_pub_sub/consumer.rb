# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
require "google/cloud/pubsub"

module SSGMessageBus
  module GCPPubSub
    class Consumer
      ATTRS = %i[
        consumer_group_id
        credentials
        gcp_ps_client
        subscription_instances
        subscriber_instances
        on_topic_message_blocks
        on_topic_error_blocks
        on_error_block
        on_exit_block
        process_data_block
        project_id
        subscriptions
        topics
      ].freeze

      attr_accessor(*ATTRS)

      def default_filter
        (@destination ? "NOT attributes.destination OR attributes.destination = \"#{@destination}\" OR attributes.destination1 = \"#{@destination}\"" : nil)
      end

      def initialize(**kwargs)
        @project_id     = kwargs[:project_id]
        @credentials    = kwargs[:credentials]

        @destination    = kwargs[:destination]
        @filter         = kwargs[:filter] || default_filter
        @topics         = kwargs[:topics] || SSGMessageBus::TOPICS

        @subscriptions = @topics.map { |t| "subscription-#{t}-#{@destination}" }
        @subscription_instances = {}
        @subscriber_instances = {}
        @on_topic_message_blocks = {}

        @gcp_ps_client  = init_client(kwargs)

        @topics.each do |current_topic|
          init_topic(current_topic)
        end

        at_exit do
          @on_exit_block&.call

          @subscriber_instances.each_value { |i| i.stop!(10) }
        end
      end

      def on_topic_message(topic, &block)
        @on_topic_message_blocks[topic] = block
      end

      def on_topic_error(topic, &block)
        @on_topic_error_blocks[topic] = block
      end

      def on_error(&block)
        @on_error_block = block
      end

      def on_exit(&block)
        @on_exit_block = block
      end

      def start
        @subscriber_instances.each_value(&:start)
      end

      private

      def init_topic(current_topic)
        # find or create topic_instance
        topic_instance = init_topic_instance(current_topic)

        current_subscription = "subscription-#{current_topic}-#{@destination}"
        # find or create subscription_instance
        subscription_instance = init_subscription_instance(topic_instance, current_subscription)

        @subscription_instances[current_topic] = subscription_instance
        @subscriber_instances[current_topic] = init_subscriber_instance(subscription_instance, current_topic)
      end

      def init_topic_instance(current_topic)
        unless @gcp_ps_client.topic(current_topic)
          @gcp_ps_client.create_topic current_topic,
                                      retention: SSGMessageBus::GCPPubSub::RETENTION_IN_SECONDS
        end

        @gcp_ps_client.topic(current_topic)
      end

      def init_subscription_instance(topic_instance, current_subscription)
        unless @gcp_ps_client.subscription current_subscription
          topic_instance.subscribe current_subscription,
                                   filter: @filter,
                                   enable_exactly_once_delivery: true,
                                   retry_policy: SSGMessageBus::GCPPubSub::RETRY_POLICY
        end

        @gcp_ps_client.subscription current_subscription
      end

      def init_subscriber_instance(subscription_instance, current_topic)
        subscriber_instance = subscription_instance.listen do |received_message|
          @on_topic_message_blocks[current_topic]
            &.call(received_message)

          received_message.acknowledge!
        end

        subscriber_instance.on_error do |exception|
          @on_topic_error_blocks[current_topic]
            &.call(exception)

          @on_error_block
            &.call(exception)
        end

        subscriber_instance
      end

      def init_client(kwargs)
        if kwargs[:emulator_host]
          ::Google::Cloud::PubSub.new(
            emulator_host: kwargs[:emulator_host],
            project_id:   @project_id
          )
        else
          ::Google::Cloud::PubSub.new(
            project_id:   @project_id,
            credentials:  @credentials
          )
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
