# frozen_string_literal: true

require_relative "gcp_pub_sub/consumer"
require_relative "gcp_pub_sub/producer"

module SSGMessageBus
  module GCPPubSub
    RETENTION_IN_SECONDS = 604_800 # 7 days
    RETRY_POLICY = Google::Cloud::PubSub::RetryPolicy
                   .new(minimum_backoff: 5, maximum_backoff: 300)
                   .freeze
  end
end
