import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    # APP_VERSION is set by the pipeline to show which build is deployed
    return f"Hello from Gabriel's platform labl version={os.getenv('APP_VERSION', 'dev')}"

# Used by Kubernetes probes and the pipeline smoke test
@app.route('/health')
def health():
    return jsonify(status='ok')
