#!/bin/bash

# PicBot AI - Setup Script

set -e

echo "🔧 Setting up PicBot AI Application"

# Check Python version
echo "Checking Python version..."
python3 --version

# Create virtual environment
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment
source .venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Create necessary directories
echo "Creating project directories..."
mkdir -p logs static templates

# Set permissions
chmod +x start.sh

echo "✅ Setup complete!"
echo ""
echo "To start the application:"
echo "  ./start.sh"
echo ""
echo "Or manually:"
echo "  source .venv/bin/activate"
echo "  gunicorn --config gunicorn_config.py app:app"
