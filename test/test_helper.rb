# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ssg_message_bus"

require "minitest/autorun"
require "minitest/pride"

ENV_KAFKA_SEED_BROKERS      = ["127.0.0.1:9092", "localhost:9092"].freeze
ENV_KAFKA_CLIENT_ID         = "kafka-client-id"
ENV_KAFKA_CONSUMER_GROUP_ID = "test-consumer-group"
ENV_KAFKA_TOPIC             = "greetings"
