# frozen_string_literal: true

require "test_helper"

class ProducerTest < Minitest::Test
  def setup
    @producer = ::SSGMessageBus::Kafka::Producer.new(
      client_id:    ENV_KAFKA_CLIENT_ID,
      seed_brokers: ENV_KAFKA_SEED_BROKERS,
      topic:        ENV_KAFKA_TOPIC
    )
  end

  def test_it_has_client_id_set
    refute_nil @producer.client_id
  end

  def test_it_has_seed_brokers_set
    refute_nil @producer.seed_brokers
  end

  def test_it_has_topic_set
    refute_nil @producer.topic
  end

  def test_it_has_kafka_client
    refute_nil @producer.kafka_client
  end
end
