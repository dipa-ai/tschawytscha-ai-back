# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Backend API for tshawytscha.ai — a chatbot ("TshaBot") that proxies conversations to OpenAI's API. Written in Go, deployed via Docker and Helm to Kubernetes on Gcore Cloud.

## Build & Run Commands

```bash
# Build
go build -o server .

# Run (requires env vars: OPENAI_API_KEY, JWT_SECRET)
OPENAI_API_KEY=... JWT_SECRET=... ./server

# Docker build
docker build -t tshawytscha-ai-back .

# Run tests (none exist yet)
go test ./...
```

## Required Environment Variables

- `OPENAI_API_KEY` — OpenAI API key (fatal on missing)
- `JWT_SECRET` — HMAC secret for JWT signing/validation (fatal on missing)
- `PORT` — HTTP listen port (default: `8080`)

## Architecture

Single-package Go application (package `main`) with two source files:

- **main.go** — HTTP server using `gorilla/mux`, OpenAI client setup, chat handler (`POST /api/chat`). The `Server` struct holds the logrus logger and OpenAI client. Chat requests include message history which is forwarded to OpenAI's chat completion API (model: `gpt-4o`).
- **auth.go** — JWT-based auth. `GET /api/init` issues a 30-day JWT cookie. `authMiddleware` protects `/api/*` routes (except `/api/init`).

## API Routes

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/api/init` | Public | Issues JWT in `auth_token` cookie |
| POST | `/api/chat` | JWT required | Proxies chat to OpenAI, returns `{"answer": "..."}` |

## Deployment

- **CI**: GitHub Actions on `v*` tags — builds multi-arch Docker image, packages and pushes Helm chart to OCI registry
- **Kubernetes**: Helm chart in `install/kubernetes/chart/`. Secrets (`openai-secret`, `jwt-secret`) injected via `envFrom`.
- **Registry**: Gcore Harbor at `registry.luxembourg-2.cloud.gcore.dev`
