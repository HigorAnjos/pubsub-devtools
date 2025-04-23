#!/bin/bash

PROJECT_ID=${PUBSUB_PROJECT_ID:-local-test-project}

TOPIC_ID="rental-attendance-attendance-totem-create-attendance"
SUBSCRIPTION_ID="rental-attendance-attendance-totem-create-attendance-sub"

DLQ_TOPIC_ID="${TOPIC_ID}-dlq"

PUBSUB_URL="http://localhost:8085/v1"

echo "📦 Criando tópico principal $TOPIC_ID"
curl -X PUT "${PUBSUB_URL}/projects/${PROJECT_ID}/topics/${TOPIC_ID}"

echo "🧨 Criando tópico DLQ $DLQ_TOPIC_ID"
curl -X PUT "${PUBSUB_URL}/projects/${PROJECT_ID}/topics/${DLQ_TOPIC_ID}"

echo "🔔 Criando assinatura com DLQ $SUBSCRIPTION_ID"
curl -X PUT "${PUBSUB_URL}/projects/${PROJECT_ID}/subscriptions/${SUBSCRIPTION_ID}" \
  -H "Content-Type: application/json" \
  -d "{
    \"topic\": \"projects/${PROJECT_ID}/topics/${TOPIC_ID}\",
    \"deadLetterPolicy\": {
      \"deadLetterTopic\": \"projects/${PROJECT_ID}/topics/${DLQ_TOPIC_ID}\",
      \"maxDeliveryAttempts\": 5
    },
    \"ackDeadlineSeconds\": 10
  }"
