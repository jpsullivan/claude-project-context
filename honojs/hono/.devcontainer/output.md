/Users/josh/Documents/GitHub/honojs/hono/.devcontainer/Dockerfile
```
FROM mcr.microsoft.com/devcontainers/typescript-node:20

# Install Deno
ENV DENO_INSTALL=/usr/local
RUN curl -fsSL https://deno.land/install.sh | sh

# Install Bun
ENV BUN_INSTALL=/usr/local
RUN curl -fsSL https://bun.sh/install | bash

WORKDIR /hono

```
/Users/josh/Documents/GitHub/honojs/hono/.devcontainer/devcontainer.json
```json
{
    "build": {
        "dockerfile": "Dockerfile"
    },
    "containerEnv": {
        "HOME": "/home/node"
    },
    "customizations": {
        "vscode": {
            "settings": {
                "deno.enable": false,
                "eslint.validate": [
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact"
                ],
                "editor.codeActionsOnSave": {
                    "source.fixAll.eslint": "explicit"
                }
            },
            "extensions": [
                "dbaeumer.vscode-eslint",
                "esbenp.prettier-vscode"
            ]
        }
    }
}

```
/Users/josh/Documents/GitHub/honojs/hono/.devcontainer/docker-compose.yml
```yaml
version: '3'

services:
  hono:
    build: .
    container_name: hono
    volumes:
      - ../:/hono
    networks:
      - hono
    command: bash
    stdin_open: true
    tty: true
    restart: 'no'

networks:
  hono:
    driver: bridge

```
