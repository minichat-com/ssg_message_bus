# frozen_string_literal: true

require "test_helper"

class ProducerTest < Minitest::Test
  def random_topic
    "topic-#{rand(1..4)}"
  end

  def setup
    @producer = SSGMessageBus::GCPPubSub::Producer.new(
                  emulator_host:  '[::1]:8092',
                  project_id:     'the-project',
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
