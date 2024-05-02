# frozen_string_literal: true

require "test_helper"

class ConsumerTest < Minitest::Test
  def random_topic
    "topic-#{rand(1..4)}"
  end

  def random_subscription
    "subscription-#{rand(1..4)}"
  end

  def setup
    @consumer = SSGMessageBus::GCPPubSub::Consumer.new(
      credentials: nil,
      emulator_host: '[::1]:8092',

      project_id:   'the-project',
      topic:        random_topic,
      subscription: random_subscription
    )
  end

  def test_it_has_project_id
    refute_nil @consumer.project_id
  end

  def test_it_has_consumer_topic
    refute_nil @consumer.topic
  end

  def test_it_has_subscription
    refute_nil @consumer.subscription
  end

  def test_it_has_gcp_ps_client
    refute_nil @consumer.gcp_ps_client
  end

  def test_it_has_topic_instance
    refute_nil @consumer.topic_instance
  end

  def test_it_has_subscription_instance
    refute_nil @consumer.subscription_instance
  end

  def test_it_has_subscriber_instance
    refute_nil @consumer.subscriber_instance
  end
end
