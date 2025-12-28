# PicBot AI - SmolVLM Image Analysis Application

A production-ready Flask application for real-time image analysis using the SmolVLM-500M-Instruct vision-language model.

## Features

- 📸 Real-time webcam image analysis
- 🖼️ Upload and analyze static images
- 🤖 Powered by HuggingFace SmolVLM-500M-Instruct
- 🚀 Production-ready with Gunicorn WSGI server
- 🔒 Ready for HTTPS deployment with reverse proxy

## Project Structure

```
picbotai/
├── app.py                 # Main Flask application
├── gunicorn_config.py     # Gunicorn production configuration
├── requirements.txt       # Python dependencies
├── templates/             # HTML templates
│   └── index.html        # Main web interface
├── static/               # Static files (CSS, JS, images)
├── logs/                 # Application logs
└── .venv/                # Virtual environment
```

## Local Development Setup

### Prerequisites

- Python 3.9+
- 4GB+ RAM (for model loading)

### Installation

1. **Clone the repository**
   ```bash
   cd /path/to/picbotai
   ```

2. **Create virtual environment**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate  # On macOS/Linux
   # .venv\Scripts\activate   # On Windows
   ```

3. **Install dependencies**
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

### Running Locally

#### Development Mode (Flask dev server)
```bash
python app.py
```

#### Production Mode (Gunicorn)
```bash
gunicorn --config gunicorn_config.py app:app
```

Access the application at: **http://127.0.0.1:8000**

## API Endpoints

### `GET /`
Serves the main web interface

### `GET /health`
Health check endpoint
```json
{
  "status": "healthy"
}
```

### `POST /process_frame`
Process and analyze an image

**Request:**
```json
{
  "image": "data:image/png;base64,...",
  "instruction": "Describe the image"
}
```

**Response:**
```json
{
  "output": "A description of the image..."
}
```

## Production Deployment

### AWS EC2 Deployment

See deployment guide in project documentation for detailed AWS deployment instructions including:
- EC2 instance setup
- Nginx reverse proxy configuration
- SSL certificate setup
- Domain configuration with GoDaddy

### Environment Variables

```bash
PORT=8000  # Application port (default: 8000)
```

### Systemd Service

For production deployment, the application runs as a systemd service with automatic restart on failure.

## Monitoring

### Check Application Status
```bash
sudo systemctl status picbotai
```

### View Logs
```bash
tail -f logs/error.log
tail -f logs/access.log
```

## Technology Stack

- **Backend:** Flask 2.3.3
- **AI Model:** HuggingFace Transformers (SmolVLM-500M-Instruct)
- **ML Framework:** PyTorch
- **WSGI Server:** Gunicorn 21.2.0
- **Image Processing:** Pillow

## License

MIT

## Author

Developed for production deployment on AWS with GoDaddy domain integration.
