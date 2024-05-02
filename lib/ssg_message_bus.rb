# frozen_string_literal: true

require_relative "ssg_message_bus/version"
require_relative "ssg_message_bus/gcp_pub_sub/consumer"
require_relative "ssg_message_bus/gcp_pub_sub/producer"

module SSGMessageBus
  class Error < StandardError; end
end
