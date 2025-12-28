# Gunicorn Configuration for PicBot AI Application

# Server socket
bind = "127.0.0.1:8000"
backlog = 2048

# Worker processes
workers = 1  # Keep at 1 due to model memory requirements
worker_class = "sync"
worker_connections = 1000
timeout = 300  # Increased timeout for model inference
keepalive = 2

# Logging
accesslog = "logs/access.log"  # Access logs
errorlog = "logs/error.log"    # Error logs
loglevel = "info"

# Process naming
proc_name = "picbotai"

# Development settings
reload = False  # Set to True if you want auto-reload on code changes
