#!/bin/bash

# PicBot AI - Local Development Start Script

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$PROJECT_DIR/logs/gunicorn.pid"

echo "🚀 Starting PicBot AI in Development Mode"

# Check if virtual environment exists
if [ ! -d "$PROJECT_DIR/.venv" ]; then
    echo "❌ Virtual environment not found. Please run setup.sh first."
    exit 1
fi

# Check if already running
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null 2>&1; then
        echo "⚠️  Application is already running (PID: $PID)"
        echo "   Access at: http://127.0.0.1:7860"
        echo "   To stop: ./stop.sh"
        exit 0
    else
        # Remove stale PID file
        rm -f "$PID_FILE"
    fi
fi

# Activate virtual environment
source "$PROJECT_DIR/.venv/bin/activate"

# Create logs directory if it doesn't exist
mkdir -p "$PROJECT_DIR/logs"

# Start application with Gunicorn
echo "✅ Starting Gunicorn server on http://127.0.0.1:8000"
echo "📝 Logs: $PROJECT_DIR/logs/"
echo "⏳ Loading AI model (this may take 30-60 seconds)..."

cd "$PROJECT_DIR"
gunicorn --config gunicorn_config.py app:app &
echo $! > "$PID_FILE"

# Wait a moment and check if it started
sleep 2
if ps -p $(cat "$PID_FILE") > /dev/null 2>&1; then
    echo "✅ Server started successfully!"
    echo "   PID: $(cat $PID_FILE)"
    echo "   URL: http://127.0.0.1:8000"
    echo ""
    echo "To stop the server: ./stop.sh"
else
    echo "❌ Failed to start server. Check logs/error.log"
    rm -f "$PID_FILE"
    exit 1
fi
