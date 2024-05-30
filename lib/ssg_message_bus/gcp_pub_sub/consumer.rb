# frozen_string_literal: true

require "google/cloud/pubsub"

module SSGMessageBus
  module GCPPubSub
    class Consumer

      ATTRS = %i[
                 project_id
                 credentials
                 topics
                 subscriptions
                 
                 gcp_ps_client

                 subscription_instances
                 subscriber_instances

                 on_topic_message_blocks
                 on_topic_error_blocks
                 on_error_block
                 on_exit_block

                 process_data_block

                 consumer_group_id].freeze
      attr_accessor(*ATTRS)

      def initialize(**kwargs)
        @project_id     = kwargs[:project_id]
        @credentials    = kwargs[:credentials]
        
        @destination    = kwargs[:destination]
        @filter         = kwargs[:filter] || ((@destination) ? "attributes.destination = \"#{@destination}\"" : nil)
        @topics         = kwargs[:topics] || SSGMessageBus::TOPICS
        
        @subscriptions  = @topics.map {|t| "subscription-#{t}-#{@destination}" }
        @subscription_instances = {}
        @subscriber_instances = {}
        @on_topic_message_blocks = {}

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
        
        @topics.each do |current_topic|
          # find or create topic_instance
          topic_instance =  unless (topic_instance = @gcp_ps_client.topic(current_topic))
                              @gcp_ps_client.create_topic current_topic, retention: SSGMessageBus::GCPPubSub::RETENTION_IN_SECONDS
                              @gcp_ps_client.topic current_topic
                            else
                              topic_instance
                            end

          current_subscription = "subscription-#{current_topic}-#{@destination}"
          # find or create subscription_instance
          subscription_instance = unless(subscription_instance = @gcp_ps_client.subscription(current_subscription))
                                    topic_instance.subscribe  current_subscription, 
                                                              filter: @filter,
                                                              enable_exactly_once_delivery: true,
                                                              retry_policy: SSGMessageBus::GCPPubSub::RETRY_POLICY
                                                              
                                    @gcp_ps_client.subscription current_subscription
                                  else
                                    @gcp_ps_client.subscription current_subscription
                                  end
          
          @subscription_instances[current_topic] = subscription_instance

          subscriber_instance = subscription_instance.listen do |received_message|                                  
                                  if (@on_topic_message_blocks[current_topic])
                                    @on_topic_message_blocks[current_topic]
                                    .call(received_message)
                                  end
                                  
                                  received_message.acknowledge!
                                end
  
          subscriber_instance.on_error do |exception|
            if(@on_topic_error_blocks[current_topic])
              @on_topic_error_blocks[current_topic]
              .call(exception)
            end

            if(@on_error_block)
              @on_error_block
              .call(exception)
            end
          end

          @subscriber_instances[current_topic] = subscriber_instance
        end

        at_exit do
          if (@on_exit_block)
            @on_exit_block.call
          end
          
          @subscriber_instances
          .values
          .each{|i| i.stop!(10)}
        end
      end

      def on_topic_message topic, &block
        @on_topic_message_blocks[topic] = block
      end

      def on_topic_error topic, &block
        @on_topic_error_blocks[topic] = block
      end

      def on_error &block
        @on_error_block = block
      end

      def on_exit &block
        @on_exit_block = block
      end

      def start
        @subscriber_instances
        .values
        .each {|i| i.start }
      end
    end
  end
end
