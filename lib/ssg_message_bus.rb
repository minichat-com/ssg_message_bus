# frozen_string_literal: true

require_relative "ssg_message_bus/version"
require_relative "ssg_message_bus/gcp_pub_sub"

module SSGMessageBus
  PARTICIPANTS = %w[videochat-admin_pic-pin-com 
                    sn-backend_minichat-com 
                    sn-backend_chatruletka-com 
                    sn-backend_videochat-cool ]
  TOPICS = %w[ping
              ban unban 
              mark-good unmark-good 
              country-override 
              room-override 
              mark-silenced unmark-silenced 
              mark-female mark-male mark-gb]

  class Error < StandardError; end
end
