#!/bin/bash

# Usage: ./run-challenge.sh [1|2|3]
CHALLENGE="$1"
if [[ -z "$CHALLENGE" || ! "$CHALLENGE" =~ ^[1-3]$ ]]; then
  echo "Usage: $0 [1|2|3]"
  exit 1
fi

wait_for_port_to_free() {
  local port=$1
  echo "⏳ Waiting for port $port to become available..."
  while lsof -i :$port -sTCP:LISTEN >/dev/null 2>&1; do
    sleep 0.5
  done
}

echo "🛑 Stopping existing server on port 8080 (if any)..."
fuser -k 8080/tcp || true

wait_for_port_to_free 8080

echo "🚀 Starting server for Challenge $CHALLENGE..."
exec python3 /opt/html/server.py

# Wait briefly for server to initialize
sleep 2

# Verify server is up
if curl --silent --head --fail "http://localhost:8080/index${CHALLENGE}.html" > /dev/null; then
  echo "✅ Verified: Page index${CHALLENGE}.html is up."
else
  echo "❌ ERROR: index${CHALLENGE}.html did not load. Check /opt/html/server.log"
fi

echo "🌐 Visit http://kubernetes-vm:8080/index${CHALLENGE}.html"