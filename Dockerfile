# Use a lightweight Python base image
FROM python:3.11-slim

WORKDIR /app

# Prevent Python from writing pyc files and enable unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# System dependency for pydub (audio decoding)
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies first (better layer caching)
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Expose Flask port
EXPOSE 5000

# Run the Flask application on 0.0.0.0:5000
CMD ["python", "-c", "from app import app, auto_load_data; auto_load_data(); app.run(host='0.0.0.0', port=5000)"]
