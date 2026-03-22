# tshawytscha-ai-back

Backend API for [tshawytscha.ai](https://tshawytscha.ai) — a chatbot powered by OpenAI's GPT-4o, manifesting as a chinook salmon that firmly denies being a fish.

## Getting Started

### Prerequisites

- Go 1.25+
- OpenAI API key

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `OPENAI_API_KEY` | Yes | — | OpenAI API key |
| `JWT_SECRET` | Yes | — | Secret for signing JWT tokens |
| `PORT` | No | `8080` | HTTP listen port |

### Run Locally

```bash
go mod download
OPENAI_API_KEY=your-key JWT_SECRET=your-secret go run .
```

### Build

```bash
go build -o server .
```

## API

### `GET /api/init`

Issues a JWT token as an `auth_token` HTTP-only cookie (valid 30 days). Must be called before using protected endpoints.

### `POST /api/chat`

Requires `auth_token` cookie.

**Request:**

```json
{
  "question": "What are you?",
  "messages": [
    {"text": "Hello", "type": "user"},
    {"text": "Hi there!", "type": "assistant"}
  ]
}
```

- `question` — required
- `messages` — optional conversation history

**Response:**

```json
{
  "answer": "I'm TshaBot, an AI entity — definitely not a fish."
}
```

## Docker

```bash
docker build -t tshawytscha-ai-back .
docker run -e OPENAI_API_KEY=your-key -e JWT_SECRET=your-secret -p 8080:8080 tshawytscha-ai-back
```

## Deployment

The project uses GitHub Actions to build and push Docker images and Helm charts on version tags (`v*`). The Helm chart is located in `install/kubernetes/chart/`.

```bash
# Deploy with Helm
helm install tshawytscha-ai-back install/kubernetes/chart/ \
  --set image.tag=v0.0.5
```

Secrets (`openai-secret`, `jwt-secret`) should be created in the cluster and are injected via `envFrom`.

## License

[Apache 2.0](LICENSE)
