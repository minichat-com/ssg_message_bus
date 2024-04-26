# frozen_string_literal: true

require "json"
require "json/add/core"

module SSGMessageBus
  class Event
    class << self
      def emit(**kwargs)
        event = new(**kwargs)

        SSGMessageBus::Kafka::Producer.to_json_produce(
          event_to_value(event)
        )
        SSGMessageBus::Kafka::Producer.deliver_messages
      end

      def event_from_value(value)
        # namespace_prefix = "::SSGMessageBus::Event::"
        # camelcased_type = value[:event_type].gsub!(/(?:_|(\/))([a-z\d]*)/i) do
        #   word = $2
        #   substituted = inflections.acronyms[word] || word.capitalize! || word
        #   $1 ? "::#{substituted}" : substituted
        # end
        # class_name = namespace_prefix + camelcased_type
        class_name = value[:event_type]
        klass = Object.const_get(class_name)
        klass.new(**value.payload)
      end

      def event_to_value(event)
        {
          event_type: event_type_of(event),
            payload: event.as_json
        }
      end

      def event_type_of(event)
        event
          .class
          .name
        # .split("::")
        # .compact
        # .last # underscore
        # .gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
        # .gsub(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
        # .tr("-".freeze, "_".freeze)
        # .downcase
      end
    end

    def as_json
      { key: :value }
    end
  end

  module Events
    class Ping < SSGMessageBus::Event
    end

    class Ban
      attr_accessor :ban_id,
                    :reason_id,
                    :ends_at,
                    :quote,
                    :user_id
    end

    PaidUnban           = Struct.new(:user_id, keyword_init: true)
    ManualUnban         = Struct.new(:user_id, keyword_init: true)
    MarkAsGood          = Struct.new(:user_id, keyword_init: true)
    UnmarkGood          = Struct.new(:user_id, keyword_init: true)
    CountryOverride     = Struct.new(:user_id, keyword_init: true)
    Silence             = Struct.new(:user_id, keyword_init: true)
    Unsilence           = Struct.new(:user_id, keyword_init: true)
    RoomOverride        = Struct.new(:user_id, keyword_init: true)
    MarkAsFemale        = Struct.new(:user_id, keyword_init: true)
    MarkAsMale          = Struct.new(:user_id, keyword_init: true)
    MarkAsSuspicious    = Struct.new(:user_id, keyword_init: true)
    MarkAsAGoodBlogger  = Struct.new(:user_id, keyword_init: true)
    VideochatLogin      = Struct.new(:user_id, keyword_init: true)
    UserStateUpdated    = Struct.new(:user_id, keyword_init: true)
  end
end
