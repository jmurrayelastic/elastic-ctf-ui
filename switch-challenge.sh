#!/bin/bash

# Usage: ./switch-challenge.sh 2
TARGET_CHALLENGE=$1

if [[ -z "$TARGET_CHALLENGE" || ! "$TARGET_CHALLENGE" =~ ^[1-3]$ ]]; then
  echo "❌ Please provide a valid challenge number (1, 2, or 3)."
  exit 1
fi

# Stop any currently running challenge service
for i in 1 2 3; do
  if systemctl is-active --quiet "run-challenge-$i"; then
    echo "🛑 Stopping Challenge $i..."
    systemctl stop "run-challenge-$i"
  fi
done

# Start the target challenge
echo "🚀 Starting Challenge $TARGET_CHALLENGE..."
systemctl start "run-challenge-$TARGET_CHALLENGE"

# Optional: Open URL in terminal-friendly way
echo "🌐 Visit http://kubernetes-vm:8080/index${TARGET_CHALLENGE}.html"
