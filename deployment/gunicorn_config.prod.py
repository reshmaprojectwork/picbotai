# Gunicorn Configuration for Production Deployment

import multiprocessing

# Server socket
bind = "127.0.0.1:8000"
backlog = 2048

# Worker processes
workers = 1  # Keep at 1 due to model memory requirements
worker_class = "sync"
worker_connections = 1000
timeout = 300  # 5 minutes timeout for model inference
keepalive = 2

# Logging
accesslog = "/var/log/picbotai/access.log"
errorlog = "/var/log/picbotai/error.log"
loglevel = "info"
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'

# Process naming
proc_name = "picbotai"

# Server mechanics
daemon = False
pidfile = "/var/run/picbotai/gunicorn.pid"
umask = 0
user = None
group = None
tmp_upload_dir = None

# SSL (if terminating SSL at Gunicorn instead of Nginx)
# keyfile = "/path/to/key.pem"
# certfile = "/path/to/cert.pem"
