# Pub/Sub Emulator + UI (Ambiente Local Completo)

Ambiente local para desenvolvimento com **Google Cloud Pub/Sub**, usando o **emulador oficial**, interface **visual (UI)** e **seed automático** com tópico e assinatura.

> Ideal para testar aplicações locais sem precisar da nuvem ou autenticação real.

---

## O que vem pronto?

- Google Pub/Sub Emulator (em modo local)
- Interface Web para gerenciamento de tópicos e mensagens
- Scripts automáticos para criar:
  - Projeto: `local-test-project`
  - Tópico: `order-processing-queue`
  - Assinatura: `order-processing-subscriber`
  - DLQ: `order-processing-queue-dlq` (Dead Letter Queue)

---

## Como rodar

### 1. Clone o repositório ou baixe os arquivos:

```bash
git clone https://github.com/HigorAnjos/pubsub-devtools
cd pubsub-devtools
```

> ou salve os arquivos `docker-compose.yml`, `entrypoint.sh` e `seed.sh` na mesma pasta.

---

### 2. Dê permissão aos scripts (Linux/macOS ou WSL):

```bash
chmod +x entrypoint.sh seed.sh
```

> No Windows, pode ignorar este passo se estiver usando Docker Desktop.

---

### 3. Suba o ambiente:

```bash
docker compose up --force-recreate --build
```

---

## Acessos

| Serviço                  | URL                         |
|--------------------------|-----------------------------|
| Pub/Sub Emulator UI  | [http://localhost:4200](http://localhost:4200) |
| Pub/Sub GRPC API     | `http://localhost:8085` |

---

## Como usar

### 1. Abrir a interface web

- Acesse: [http://localhost:4200](http://localhost:4200)
- Clique em **"Attach new project"**
- Digite: `local-test-project`
- Clique em **"Save"**

---

### 2. Corrigir o host (se necessário)

Se aparecer a mensagem `select a topic & subscription to continue`, vá até a engrenagem  no canto superior direito e:

- Altere `current host` para: `http://localhost:8085`

---

### 3. Visualize e interaja

- Após configurar o host, você terá acesso a:
  - Tópico principal: `order-processing-queue`
  - Assinatura: `order-processing-subscriber`
  - DLQ: `order-processing-queue-dlq`
- Você pode enviar e receber mensagens pela interface
- E integrar com sua aplicação .NET

---

### 4. Usar com .NET

Para configurar o PubSub no seu projeto .NET, você tem três opções:

#### 4.1. Configurar via Environment Variable

1. **No código (Program.cs ou Startup.cs)**:
```csharp
Environment.SetEnvironmentVariable("PUBSUB_EMULATOR_HOST", "localhost:8085");
```

2. **No arquivo launchSettings.json** (Recomendado):
```json
{
  "profiles": {
    "Development": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": false,
      "applicationUrl": "http://localhost:5000",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development",
        "PUBSUB_EMULATOR_HOST": "localhost:8085"
      }
    }
  }
}
```

> **Dica**: A única variável realmente necessária é `PUBSUB_EMULATOR_HOST`, que aponta para o emulador local.

3. **No arquivo appsettings.json**:
```json
{
  "PubSub": {
    "EmulatorHost": "localhost:8085"
  }
}
```

E no código:
```csharp
var pubSubHost = configuration.GetValue<string>("PubSub:EmulatorHost");
Environment.SetEnvironmentVariable("PUBSUB_EMULATOR_HOST", pubSubHost);
```

#### 4.2. Configurar via Builder

Alternativamente, configure diretamente no builder do PubSub:

```csharp
using Google.Cloud.PubSub.V1;

var builder = new PublisherClientBuilder
{
    EmulatorDetection = EmulatorDetection.EmulatorOnly
};

// Ou ao criar o subscriber
var subscriberBuilder = new SubscriberClientBuilder
{
    EmulatorDetection = EmulatorDetection.EmulatorOnly
};
```

> **Importante**: Configure o emulador antes de criar qualquer cliente PubSub.

---

## Arquitetura dos containers

```yaml
services:
  pubsub-emulator:
    image: google/cloud-sdk:latest
    ports: ["8085:8085"]
    volumes: ["./entrypoint.sh:/entrypoint.sh", "./seed.sh:/seed.sh"]
    entrypoint: ["/bin/bash", "-c", "/entrypoint.sh"]

  pubsub-ui:
    image: ghcr.io/neoscript/pubsub-emulator-ui:latest
    ports: ["4200:80"]
    environment:
      - PUBSUB_EMULATOR_HOST=pubsub-emulator:8085
    depends_on: [pubsub-emulator]
```

---

## Arquivos incluídos

| Arquivo             | Função                                       |
|---------------------|----------------------------------------------|
| `docker-compose.yml`| Orquestra os serviços do emulador e da UI   |
| `entrypoint.sh`     | Inicia o emulador e executa o seed automático |
| `seed.sh`           | Cria tópico e assinatura via API REST local |

---

## Créditos

- [Google Cloud Pub/Sub Emulator](https://cloud.google.com/pubsub/docs/emulator)
- [PubSub Emulator UI - NeoScript](https://github.com/NeoScript/pubsub-ui)

---
