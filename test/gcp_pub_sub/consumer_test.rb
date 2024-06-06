# frozen_string_literal: true

require "test_helper"

require_relative "../config"

class ConsumerTest < Minitest::Test
  def setup
    @consumer = SSGMessageBus::GCPPubSub::Consumer.new(
      emulator_host:  ENV_MESSAGE_BUS_EMULATOR_HOST,
      project_id:     ENV_MESSAGE_BUS_PROJECT_ID
    )
  end

  def test_it_has_project_id
    refute_nil @consumer.project_id
  end

  def test_it_has_consumer_topics
    refute_empty @consumer.topics
  end

  def test_it_has_subscriptions
    refute_nil @consumer.subscriptions
  end

  def test_it_has_gcp_ps_client
    refute_nil @consumer.gcp_ps_client
  end

  def test_it_has_topic_instances
    refute_nil @consumer.topics
  end

  def test_it_has_subscription_instances
    refute_nil @consumer.subscription_instances
  end

  def test_it_has_subscriber_instances
    refute_nil @consumer.subscriber_instances
  end
end
