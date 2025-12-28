# PicBot AI - AWS Deployment Guide for picbotai.com

Complete step-by-step guide to deploy PicBot AI on AWS EC2 with your GoDaddy domain.

## 📋 Prerequisites

- AWS Account
- GoDaddy domain: **picbotai.com** (already purchased)
- SSH client
- Basic terminal knowledge

## 🚀 Part 1: AWS EC2 Setup

### Step 1: Launch EC2 Instance

1. **Login to AWS Console** → EC2 Dashboard

2. **Launch Instance**
   - **Name:** `picbotai-production`
   - **AMI:** Ubuntu Server 22.04 LTS (64-bit x86)
   - **Instance Type:** `t3.medium` or higher
     - vCPUs: 2+
     - Memory: 4GB+ (8GB recommended for smooth model loading)
   - **Key Pair:** Create new or use existing (download `.pem` file)
   - **Storage:** 30GB gp3 EBS volume

3. **Configure Security Group**
   
   Create rules:
   ```
   Type            Protocol    Port Range    Source
   SSH             TCP         22            Your IP (for security)
   HTTP            TCP         80            0.0.0.0/0
   HTTPS           TCP         443           0.0.0.0/0
   Custom TCP      TCP         8000          127.0.0.1/32 (internal only)
   ```

4. **Allocate Elastic IP**
   - Go to: EC2 → Elastic IPs → Allocate Elastic IP
   - Associate with your EC2 instance
   - **Note this IP** - you'll need it for DNS setup

### Step 2: Connect to EC2

```bash
# Set permissions on your key file
chmod 400 your-key.pem

# Connect to EC2
ssh -i your-key.pem ubuntu@YOUR_ELASTIC_IP
```

## 🌐 Part 2: GoDaddy DNS Configuration

### Configure DNS Records

1. **Login to GoDaddy** → My Products → DNS

2. **Add/Update A Records:**

   | Type | Name | Value              | TTL  |
   |------|------|--------------------|------|
   | A    | @    | YOUR_ELASTIC_IP    | 600  |
   | A    | www  | YOUR_ELASTIC_IP    | 600  |

3. **Wait 15-30 minutes** for DNS propagation

4. **Verify DNS:**
   ```bash
   # From your local machine
   nslookup picbotai.com
   nslookup www.picbotai.com
   
   # Should return your Elastic IP
   ```

## 📦 Part 3: Deploy Application to EC2

### Option A: Upload via SCP (Recommended)

```bash
# From your local machine in the project directory
cd /path/to/picbotai

# Upload entire project
scp -i your-key.pem -r . ubuntu@YOUR_ELASTIC_IP:/home/ubuntu/picbotai/
```

### Option B: Using Git

```bash
# On EC2 instance
git clone YOUR_REPO_URL /home/ubuntu/picbotai
cd /home/ubuntu/picbotai
```

### Run Deployment Script

```bash
# On EC2 instance
cd /home/ubuntu/picbotai
chmod +x deployment/deploy.sh
./deployment/deploy.sh
```

The script will:
- ✅ Update system packages
- ✅ Install Python, Nginx, Certbot
- ✅ Create virtual environment
- ✅ Install dependencies
- ✅ Configure systemd service
- ✅ Setup Nginx reverse proxy
- ✅ Start the application

## 🔒 Part 4: SSL Certificate (HTTPS)

### Install Let's Encrypt SSL Certificate

```bash
# On EC2 instance
sudo certbot --nginx -d picbotai.com -d www.picbotai.com
```

**Follow prompts:**
1. Enter email address
2. Agree to Terms of Service
3. Choose: Redirect HTTP to HTTPS (Option 2)

**Certificate auto-renewal:**
```bash
# Test renewal
sudo certbot renew --dry-run

# Auto-renewal is configured via cron/systemd timer
```

## ✅ Part 5: Verify Deployment

### Check Service Status

```bash
# Application service
sudo systemctl status picbotai

# Nginx service
sudo systemctl status nginx

# View logs
sudo journalctl -u picbotai -f
tail -f /var/log/picbotai/error.log
```

### Test Endpoints

```bash
# Health check
curl https://picbotai.com/health

# Should return: {"status":"healthy"}
```

### Browser Test

Open in browser:
- **https://picbotai.com**
- **https://www.picbotai.com**

You should see the PicBot AI interface!

## 🔧 Management Commands

### Service Control

```bash
# Start application
sudo systemctl start picbotai

# Stop application
sudo systemctl stop picbotai

# Restart application
sudo systemctl restart picbotai

# View status
sudo systemctl status picbotai

# Enable auto-start on boot
sudo systemctl enable picbotai
```

### View Logs

```bash
# Application logs (live)
sudo journalctl -u picbotai -f

# Error logs
tail -f /var/log/picbotai/error.log

# Access logs
tail -f /var/log/picbotai/access.log

# Nginx logs
tail -f /var/log/nginx/picbotai_error.log
tail -f /var/log/nginx/picbotai_access.log
```

### Update Application

```bash
# Pull latest code
cd /home/ubuntu/picbotai
git pull  # or upload new files via SCP

# Restart service
sudo systemctl restart picbotai
```

## 📊 Monitoring

### Check Resource Usage

```bash
# CPU and Memory
htop

# Disk usage
df -h

# Process info
ps aux | grep gunicorn
```

### CloudWatch (Optional)

Enable CloudWatch monitoring in AWS Console for:
- CPU utilization
- Network traffic
- Disk I/O
- Custom application metrics

## 🔥 Troubleshooting

### Application won't start

```bash
# Check logs
sudo journalctl -u picbotai -n 50

# Check port availability
sudo lsof -i :8000

# Verify Python dependencies
source /home/ubuntu/picbotai/.venv/bin/activate
pip list
```

### Nginx errors

```bash
# Test configuration
sudo nginx -t

# Reload configuration
sudo systemctl reload nginx

# Check error log
tail -f /var/log/nginx/error.log
```

### DNS not resolving

```bash
# Clear local DNS cache (on your computer)
# macOS:
sudo dscacheutil -flushcache

# Check DNS propagation
dig picbotai.com
```

### SSL certificate issues

```bash
# Check certificate status
sudo certbot certificates

# Force renewal
sudo certbot renew --force-renewal

# Check Nginx SSL config
sudo nginx -t
```

## 🎯 Production Checklist

- [ ] EC2 instance running with Elastic IP
- [ ] Security group configured (ports 80, 443, 22)
- [ ] DNS A records pointing to Elastic IP
- [ ] Application deployed and running
- [ ] Systemd service enabled and active
- [ ] Nginx configured and running
- [ ] SSL certificate installed (HTTPS working)
- [ ] Health endpoint responding
- [ ] Web interface accessible
- [ ] Logs rotating properly
- [ ] Auto-start on reboot enabled

## 🔗 Important URLs

- **Production Site:** https://picbotai.com
- **Health Check:** https://picbotai.com/health
- **AWS EC2 Console:** https://console.aws.amazon.com/ec2
- **GoDaddy DNS:** https://dcc.godaddy.com/manage/dns

## 💰 Cost Estimation (Monthly)

- **EC2 t3.medium:** ~$30-40/month
- **30GB EBS Storage:** ~$3/month
- **Elastic IP:** Free (when attached)
- **Data Transfer:** Variable (~$0.09/GB)
- **SSL Certificate:** Free (Let's Encrypt)

**Estimated Total:** $35-50/month

## 🚀 Optimization Tips

1. **Use CloudFront CDN** for faster global access
2. **Enable gzip compression** in Nginx for faster loading
3. **Set up CloudWatch alarms** for monitoring
4. **Regular backups** via AWS Snapshots
5. **Auto-scaling** for high traffic (future)

## 📞 Support

For issues:
1. Check logs first
2. Verify DNS propagation
3. Test SSL certificate
4. Review security group rules
5. Check AWS service health dashboard

---

**🎉 Congratulations!** Your PicBot AI application is now live at **https://picbotai.com**
