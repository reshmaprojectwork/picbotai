#!/bin/bash

# PicBot AI - Stop Script

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$PROJECT_DIR/logs/gunicorn.pid"

echo "🛑 Stopping PicBot AI..."

if [ ! -f "$PID_FILE" ]; then
    echo "⚠️  PID file not found. Checking for running processes..."
    pkill -f "gunicorn.*app:app" && echo "✅ Stopped running processes" || echo "ℹ️  No running processes found"
    exit 0
fi

PID=$(cat "$PID_FILE")

if ps -p $PID > /dev/null 2>&1; then
    kill $PID
    echo "✅ Stopped PicBot AI (PID: $PID)"
    rm -f "$PID_FILE"
else
    echo "⚠️  Process not running (PID: $PID)"
    rm -f "$PID_FILE"
fi

# Double check and kill any remaining gunicorn processes
pkill -f "gunicorn.*app:app" 2>/dev/null && echo "✅ Cleaned up remaining processes" || true
