# Start from the official Kestra image
FROM kestra/kestra:latest

# Switch to the root user to install software
USER root

# Install git
RUN apt-get update && apt-get install -y git

# Copy our clean config file directly into the image
COPY application.yaml /app/config/application.yml