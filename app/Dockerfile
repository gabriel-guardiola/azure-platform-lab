FROM python:3.12-slim
WORKDIR /app

# Copy reuirements first so the pip install layer is cached when only code changes
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .

# Run as non-root for security
RUN useradd -m appuser
USER appuser

EXPOSE 8080
# Bind to 0.0.0.0 so the app is reachable from outside the container
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
