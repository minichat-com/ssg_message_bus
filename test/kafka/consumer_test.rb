# frozen_string_literal: true

require "test_helper"

class ConsumerTest < Minitest::Test
  def setup
    @consumer = ::SSGMessageBus::Kafka::Consumer.new(
      client_id:         ENV_KAFKA_CLIENT_ID,
      consumer_group_id: ENV_KAFKA_CONSUMER_GROUP_ID,
      seed_brokers:      ENV_KAFKA_SEED_BROKERS,
      topic:             ENV_KAFKA_TOPIC
    )
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
end
