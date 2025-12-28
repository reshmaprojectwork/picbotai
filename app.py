# -*- coding: utf-8 -*-
"""
PicBot AI - SmolVLM Image Analysis Application
A Flask application for real-time image analysis using SmolVLM-500M-Instruct model.
"""

from flask import Flask, request, jsonify, render_template
from transformers import AutoProcessor, AutoModelForVision2Seq
from PIL import Image
import torch
import io
import base64
import logging
import os

app = Flask(__name__)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

# --- Load SmolVLM Model ---
MODEL_ID = "HuggingFaceTB/SmolVLM-500M-Instruct"
device = torch.device("cpu")

print(f"Loading model: {MODEL_ID}")
processor = AutoProcessor.from_pretrained(MODEL_ID)
model = AutoModelForVision2Seq.from_pretrained(MODEL_ID, torch_dtype=torch.float32).to(device)

# --- Serve Frontend ---
@app.route('/')
def index():
    """Serve the main application page."""
    return render_template('index.html')

# --- Serve ads.txt ---
@app.route('/ads.txt')
def ads_txt():
    """Serve ads.txt file for ad verification."""
    with open('ads.txt', 'r') as f:
        return f.read(), 200, {'Content-Type': 'text/plain'}

# --- Health Check ---
@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

# --- Process Image ---
@app.route('/process_frame', methods=['POST'])
def process_frame():
    try:
        data = request.get_json()
        img_b64 = data.get("image", "")
        instruction = data.get("instruction", "Describe the image.")

        # Decode base64 image
        image_data = base64.b64decode(img_b64.split(",")[1])
        image = Image.open(io.BytesIO(image_data)).convert("RGB")

        # Prepare prompt
        prompt = [f"<image>\n{instruction}"]

        # Process input
        inputs = processor(images=[image], text=prompt, return_tensors="pt").to(device)

        # Generate output
        with torch.no_grad():
            output = model.generate(**inputs, max_new_tokens=120)

        caption = processor.decode(output[0], skip_special_tokens=True)

        return jsonify({"output": caption})
    
    except Exception as e:
        app.logger.error(f"Error processing frame: {str(e)}")
        return jsonify({"error": "Failed to process image"}), 500

if __name__ == '__main__':
    # For development only - use Gunicorn for production
    port = int(os.environ.get('PORT', 8000))
    app.run(host='0.0.0.0', port=port, debug=True, use_reloader=False)
