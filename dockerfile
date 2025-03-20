# Use Python as the base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install Cron and other dependencies
RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application files
COPY . .

# Install dotenv to handle environment variables
RUN pip install python-dotenv

# Add a cron job to execute the script every Monday at 7:30 AM
RUN echo "30 7 * * 1 root python /app/discover-weekly.py >> /var/log/cron.log 2>&1" > /etc/cron.d/auto-radio \
    && chmod 0644 /etc/cron.d/auto-radio \
    && crontab /etc/cron.d/auto-radio

# Start cron in foreground
CMD ["cron", "-f"]
