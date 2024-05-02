# frozen_string_literal: true

require "google/cloud/pubsub"

module SSGMessageBus
  module GCPPubSub
    class Consumer

      ATTRS = %i[
                 project_id
                 credentials
                 topic
                 subscription
                 
                 gcp_ps_client
                 topic_instance
                 subscription_instance
                 subscriber_instance

                 on_message_block
                 on_error_block
                 on_exit_block

                 process_data_block

                 consumer_group_id].freeze
      attr_accessor(*ATTRS)

      def initialize(**kwargs)
        @project_id   = kwargs[:project_id]
        @credentials  = kwargs[:credentials]
        @topic        = kwargs[:topic]
        @subscription = kwargs[:subscription]

        @gcp_ps_client  = if kwargs[:emulator_host]
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
        
        @topic_instance =  unless (@topic_instance = @gcp_ps_client.topic @topic)
          @gcp_ps_client.create_topic @topic
          @gcp_ps_client.topic @topic
        else
          @topic_instance
        end

        @subscription_instance = unless (@subscription_instance = @gcp_ps_client.subscription @subscription)
          @topic_instance.subscribe @subscription, enable_exactly_once_delivery: true
          @gcp_ps_client.subscription @subscription
        else
          @gcp_ps_client.subscription @subscription
        end

        @subscriber_instance = subscription_instance.listen do |received_message|
          if (@on_message_block)
            @on_message_block.call(received_message)
          
            received_message.acknowledge!
          end
        end

        @subscriber_instance.on_error do |exception|
          if (@on_error_block)
            @on_error_block.call(exception)
          end
        end

        at_exit do
          if (@on_exit_block)
            @on_exit_block.call
          end
          
          @subscriber_instance.stop!(10)
        end
      end

      def on_message &block
        @on_message_block = block
      end

      def on_error &block
        on_error_block = block
      end

      def on_exit &block
        on_exit_block = block
      end

      def start
        @subscriber_instance.start
      end
    end
  end
end
