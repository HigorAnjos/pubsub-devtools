# 📨 Pub/Sub Emulator + UI (Ambiente Local Completo)

Ambiente local para desenvolvimento com **Google Cloud Pub/Sub**, usando o **emulador oficial**, interface **visual (UI)** e **seed automático** com tópico e assinatura.

> Ideal para testar aplicações locais sem precisar da nuvem ou autenticação real.

---

## 📦 O que vem pronto?

- 🧠 Google Pub/Sub Emulator (em modo local)
- 🖥️ Interface Web para ver tópicos, mensagens e assinaturas
- ⚙️ Scripts automáticos para criar:
  - Projeto: `local-test-project`
  - Tópico: `rental-attendance-attendance-totem-create-attendance`
  - Assinatura: `rental-attendance-attendance-totem-create-attendance-sub`

---

## 🚀 Como rodar

### 1. Clone o repositório ou baixe os arquivos:

```bash
git clone https://github.com/seu-usuario/pubsub-emulator-devtools.git
cd pubsub-emulator-devtools
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

## 🌐 Acessos

| Serviço                  | URL                         |
|--------------------------|-----------------------------|
| 🎛️ Pub/Sub Emulator UI  | [http://localhost:4200](http://localhost:4200) |
| ⚙️ Pub/Sub GRPC API     | `http://localhost:8085` |

---

## ✅ Como usar

### 1. Abrir a interface web

- Acesse: [http://localhost:4200](http://localhost:4200)
- Clique em **"Attach new project"**
- Digite:  
  ```
  local-test-project
  ```
- Clique em **"Save"**

---

### 2. Corrigir o host (se necessário)

Se aparecer a mensagem `select a topic & subscription to continue`, vá até a engrenagem ⚙️ no canto superior direito e:

- Altere `current host` de:
  ```
  http://localhost:8681
  ```
  para:
  ```
  http://localhost:8085
  ```

---

### 3. Visualize e interaja

- Após configurar o host corretamente, o projeto será carregado com:
  - Um tópico criado automaticamente
  - Uma assinatura associada
- Você pode enviar mensagens manualmente pela interface
- E também consumi-las no seu sistema .NET

---

### 4. Usar com .NET

Configure o PubSub no seu projeto com:

```csharp
Environment.SetEnvironmentVariable("PUBSUB_EMULATOR_HOST", "localhost:8085");
```

Ou:

```csharp
builder.EmulatorDetection = EmulatorDetection.EmulatorOnly;
```

---

## 🛠️ Arquitetura dos containers

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

## 📂 Arquivos incluídos

| Arquivo             | Função                                       |
|---------------------|----------------------------------------------|
| `docker-compose.yml`| Orquestra os serviços do emulador e da UI   |
| `entrypoint.sh`     | Inicia o emulador e executa o seed automático |
| `seed.sh`           | Cria tópico e assinatura via API REST local |

---

## 🤝 Créditos

- [Google Cloud Pub/Sub Emulator](https://cloud.google.com/pubsub/docs/emulator)
- [PubSub Emulator UI - NeoScript](https://github.com/NeoScript/pubsub-ui)

---
