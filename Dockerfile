# Use the official slim Python 3.11 base image (lightweight)
FROM python:3.11-slim

# Install git and curl (needed for cloning repos and troubleshooting HTTP requests)
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# Prepare SSH known_hosts to avoid manual prompt when accessing GitHub over SSH
RUN mkdir -p /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

# Set the working directory inside the container
WORKDIR /app

# Copy only the requirements first to leverage Docker layer caching
COPY requirements.txt .

# Install required Python packages from requirements.txt
RUN pip install -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Set the default command to run the Python script
CMD ["python", "sync.py"]
