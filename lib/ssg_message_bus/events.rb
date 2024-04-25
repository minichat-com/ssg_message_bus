# frozen_string_literal: true

module SSGMessageBus
  module Events
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
