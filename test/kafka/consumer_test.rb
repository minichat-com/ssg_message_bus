# frozen_string_literal: true

require "test_helper"

class ConsumerTest < Minitest::Test
  def setup
    ::SSGMessageBus::Kafka::Consumer.init(
      client_id:         ENV_KAFKA_CLIENT_ID,
      consumer_group_id: ENV_KAFKA_CONSUMER_GROUP_ID,
      seed_brokers:      ENV_KAFKA_SEED_BROKERS,
      topic:             ENV_KAFKA_TOPIC
    )

    @consumer = ::SSGMessageBus::Kafka::Consumer
  end

  def test_it_has_client_id_set
    refute_nil @consumer.client_id
  end

  def test_it_has_consumer_group_id_set
    refute_nil @consumer.consumer_group_id
  end

  def test_it_has_seed_brokers_set
    refute_nil @consumer.seed_brokers
  end

  def test_it_has_topic_set
    refute_nil @consumer.topic
  end

  def test_it_has_kafka_client
    refute_nil @consumer.kafka_client
  end
end
