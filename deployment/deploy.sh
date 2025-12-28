#!/bin/bash

# AWS EC2 Deployment Script for PicBot AI
# Run this script on your EC2 instance after uploading the code

set -e

echo "=========================================="
echo "   PicBot AI - AWS EC2 Deployment"
echo "=========================================="

# Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt-get install -y python3-pip python3-venv nginx certbot python3-certbot-nginx

# Create application directory if deploying fresh
APP_DIR="/home/ubuntu/picbotai"
if [ ! -d "$APP_DIR" ]; then
    echo "❌ Application directory not found: $APP_DIR"
    echo "Please upload your application files first."
    exit 1
fi

cd $APP_DIR

# Create Python virtual environment
echo "🐍 Creating Python virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# Install Python packages
echo "📦 Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Create log directories
echo "📝 Creating log directories..."
sudo mkdir -p /var/log/picbotai
sudo mkdir -p logs
sudo chown -R ubuntu:www-data /var/log/picbotai
sudo chown -R ubuntu:www-data logs

# Setup systemd service
echo "⚙️  Setting up systemd service..."
sudo cp deployment/picbotai.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable picbotai
sudo systemctl start picbotai

# Setup Nginx
echo "🌐 Setting up Nginx..."
sudo cp deployment/nginx.conf /etc/nginx/sites-available/picbotai
sudo ln -sf /etc/nginx/sites-available/picbotai /etc/nginx/sites-enabled/

# Remove default Nginx site
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx

# Check service status
echo ""
echo "✅ Deployment Complete!"
echo ""
echo "=========================================="
echo "Service Status:"
sudo systemctl status picbotai --no-pager
echo "=========================================="
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Configure your GoDaddy DNS for picbotai.com:"
echo "   - Add A Record: @ -> Your EC2 Elastic IP"
echo "   - Add A Record: www -> Your EC2 Elastic IP"
echo ""
echo "2. Wait 15-30 minutes for DNS propagation"
echo ""
echo "3. Setup SSL certificate:"
echo "   sudo certbot --nginx -d picbotai.com -d www.picbotai.com"
echo ""
echo "4. Test your application:"
echo "   https://picbotai.com"
echo ""
echo "=========================================="
echo "Useful Commands:"
echo ""
echo "Check service status:"
echo "  sudo systemctl status picbotai"
echo ""
echo "View logs:"
echo "  sudo journalctl -u picbotai -f"
echo "  tail -f /var/log/picbotai/error.log"
echo ""
echo "Restart service:"
echo "  sudo systemctl restart picbotai"
echo ""
echo "=========================================="
