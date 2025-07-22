#!/bin/bash

# Usage: ./run-challenge.sh [1|2|3]

CHALLENGE="$1"
if [[ -z "$CHALLENGE" || ! "$CHALLENGE" =~ ^[1-3]$ ]]; then
  echo "Usage: $0 [1|2|3]"
  exit 1
fi

echo "🔧 Stopping existing server on port 8080 (if any)..."
fuser -k 8080/tcp || true
sleep 4

echo "🚀 Starting server for Challenge $CHALLENGE..."
python3 /opt/html/server.py &

sleep 1
echo "✅ Server running."
echo "🔗 Open http://kubernetes-vm:8080/index${CHALLENGE}.html"
