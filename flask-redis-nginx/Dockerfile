# Use official Python image
FROM python:3.11-slim

# Set work directory
WORKDIR /app

# Copy app files
COPY app/ /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]

