# frozen_string_literal: true

require "google/cloud/pubsub"

module SSGMessageBus
  module GCPPubSub
    class Producer

      ATTRS = %i[project_id credentials topic gcp_ps_client topic_instance].freeze
      attr_accessor(*ATTRS)


      def initialize(**kwargs)
        @project_id   = kwargs[:project_id]
        @credentials  = kwargs[:credentials]
        @topic        = kwargs[:topic]

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

        @topic_instance =  unless (@topic_instance = @gcp_ps_client.topic @topic)
          @gcp_ps_client.create_topic @topic
          @gcp_ps_client.topic @topic
        else
          @topic_instance
        end
      end

      def publish(data)
        # gcp_ps_producer.publish data
        # gcp_ps_producer.publish data
        @topic_instance.publish data
      end

    end
  end
end
