#!/bin/bash

DOTENV_FILE="./.env"
DOCKER_ENV_FILE="./.docker.env"

REQUIRED_VARS=(
    "OPEN_NOTEBOOK_PASSWORD"
    "SURREAL_URL"
    "SURREAL_USER"
    "SURREAL_PASSWORD"
    "SURREAL_NAMESPACE"
    "SURREAL_DATABASE"
    "OPENAI_API_KEY"
    "ANTHROPIC_API_KEY"
    "GEMINI_API_KEY"
    "VERTEX_PROJECT"
    "GOOGLE_APPLICATION_CREDENTIALS"
    "VERTEX_LOCATION"
    "DEEPSEEK_API_KEY"
    "MISTRAL_API_KEY"
    "GROQ_API_KEY"
    "XAI_API_KEY"
    "ELEVENLABS_API_KEY"
    "OLLAMA_API_BASE"
    "OPENROUTER_BASE_URL"
    "OPENROUTER_API_KEY"
    "AZURE_OPENAI_API_KEY"
    "AZURE_OPENAI_ENDPOINT"
    "AZURE_OPENAI_API_VERSION"
    "AZURE_OPENAI_DEPLOYMENT_NAME"
    "OPENAI_COMPATIBLE_BASE_URL"
    "OPENAI_COMPATIBLE_API_KEY"
    "FIRECRAWL_API_KEY"
    "JINA_API_KEY"
    "VOYAGE_API_KEY"
    "LANGCHAIN_TRACING_V2"
    "LANGCHAIN_ENDPOINT"
    "LANGCHAIN_API_KEY"
    "LANGCHAIN_PROJECT"
)

> $DOCKER_ENV_FILE
cat > $DOCKER_ENV_FILE << 'EOF'
SURREAL_URL=ws://localhost:8000/rpc
SURREAL_USER=root
SURREAL_PASSWORD=root
SURREAL_NAMESPACE=open_notebook
SURREAL_DATABASE=production
EOF

while IFS= read -r line || [ -n "$line" ]; do
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
        key="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
        export "$key"="$value"
    fi
done < "$DOTENV_FILE"

for var in "${REQUIRED_VARS[@]}"; do
    value="${!var}"
    
    if [ -n "$value" ]; then
        echo "$var=$value" >> "$DOCKER_ENV_FILE"
    fi
done
