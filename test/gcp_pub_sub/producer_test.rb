# frozen_string_literal: true

require "test_helper"

require_relative "../config"

class ProducerTest < Minitest::Test
  def setup
    @producer = SSGMessageBus::GCPPubSub::Producer.new(
                  emulator_host:  ENV_MESSAGE_BUS_EMULATOR_HOST,
                  project_id:     ENV_MESSAGE_BUS_PROJECT_ID
                )
  end

  def test_it_has_project_id
    refute_nil @producer.project_id
  end

  def test_it_has_topicі_set
    refute_empty @producer.topics
  end

  def test_it_has_kafka_client
    refute_nil @producer.gcp_ps_client
  end
end
