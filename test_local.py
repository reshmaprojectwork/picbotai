from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

@app.route('/process_frame', methods=['POST'])
def process_frame():
    # Mock response for testing
    return jsonify({
        "output": "This is a test response. The actual AI model is too large to run locally."
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
