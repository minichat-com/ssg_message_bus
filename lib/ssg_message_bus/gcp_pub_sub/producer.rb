# frozen_string_literal: true

require "google/cloud/pubsub"

module SSGMessageBus
  module GCPPubSub
    class Producer

      ATTRS = %i[project_id credentials topics gcp_ps_client topic_instances].freeze
      attr_accessor(*ATTRS)


      def initialize(**kwargs)
        @project_id   = kwargs[:project_id]
        @credentials  = kwargs[:credentials]
        
        @destination  = kwargs[:destination]
        @topics       = kwargs[:topics] || SSGMessageBus::TOPICS

        @topic_instances = {}

        @gcp_ps_client  = if kwargs[:emulator_host]
                            ::Google::Cloud::PubSub.new(
                              emulator_host:  kwargs[:emulator_host],
                              project_id:     @project_id
                            )
                          else
                            ::Google::Cloud::PubSub.new(
                              project_id:   @project_id,
                              credentials:  @credentials
                            )
                          end

        @topics.each do |current_topic|
          topic_instance =  unless (topic_instance = @gcp_ps_client.topic current_topic)
                              @gcp_ps_client.create_topic current_topic
                              @gcp_ps_client.topic current_topic
                            else
                              topic_instance
                            end

          @topic_instances[current_topic] = topic_instance
        end
      end

      def publish(topic:, data: {}, attributes: {}, source:, destination:)
        safe_data = data || {}
        safe_attributes = (attributes || {}).merge({
                            'destination' => destination,
                            'source' => source
                          })
        
        @topic_instances[topic]
        .publish(safe_data, safe_attributes)
      end

    end
  end
end
