# frozen_string_literal: true

require "test_helper"

require_relative "../config"

class ProducerTest < Minitest::Test
  def random_topic
    "topic-#{rand(1..4)}"
  end

  def setup
    @producer = SSGMessageBus::GCPPubSub::Producer.new(
                  emulator_host: ENV_MESSAGE_BUS_EMULATOR_HOST,
                  project_id:   ENV_MESSAGE_BUS_PROJECT_ID,
                  topic:          random_topic
                )
  end

  def test_it_has_project_id
    refute_nil @producer.project_id
  end

  def test_it_has_topic_set
    refute_nil @producer.topic
  end

  def test_it_has_kafka_client
    refute_nil @producer.gcp_ps_client
  end
end
