#!/bin/bash
set -e

# Inicia o Pub/Sub Emulator
gcloud beta emulators pubsub start --host-port=0.0.0.0:8085 &
EMULATOR_PID=$!

# Aguarda o emulador subir
sleep 5

# Exporta variáveis
export PUBSUB_EMULATOR_HOST=localhost:8085
export PUBSUB_PROJECT_ID=${PUBSUB_PROJECT_ID:-local-test-project}

# Cria config se não existir
gcloud config configurations list --format="value(name)" | grep -qx "emulator-config" || \
  gcloud config configurations create emulator-config

gcloud config configurations activate emulator-config
gcloud config set project "$PUBSUB_PROJECT_ID"
gcloud config set auth/disable_credentials true

# Roda o seed (tópico + sub)
bash /seed.sh

# Mantém o container rodando
wait $EMULATOR_PID
