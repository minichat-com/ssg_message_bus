# frozen_string_literal: true

require "test_helper"

class SSGMessageBusTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SSGMessageBus::VERSION
  end

  def test_it_has_namespace_for_events
    refute_nil ::SSGMessageBus::Events
  end
end
