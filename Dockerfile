FROM ubuntu:22.04

# Set environment variables to avoid any interactive dialogue
# from the installation processes
ENV DEBIAN_FRONTEND=noninteractive

# Install Python and pip
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3.9 \
    python3-pip  \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /usr/src/app

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    libtbb-dev \
    libtbb2 \
    libtbbmalloc2 \
    liblapack-dev \
    libblas-dev \
    libarmadillo-dev \
    libsndfile1-dev \
    curl \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv
RUN pip install --no-cache-dir pipenv

# Download and setup phaselimiter
RUN cd /tmp && \
    curl -OL https://github.com/ai-mastering/phaselimiter/releases/download/v0.2.0/release.tar.xz && \
    tar -Jxvf release.tar.xz && \
    mkdir -p /etc/phaselimiter && \
    cp -R phaselimiter/* /etc/phaselimiter/ && \
    cp phaselimiter/.python-version /etc/phaselimiter/ && \
    chmod +x /etc/phaselimiter/bin/* && \
    cp /etc/phaselimiter/bin/* /usr/local/bin && \
    chmod +x /etc/phaselimiter/script/audio_detector && \
    cp /etc/phaselimiter/script/audio_detector /usr/local/bin

# Define environment variable
ENV PATH="/etc/phaselimiter/bin:${PATH}"

# Test phaselimiter
RUN phase_limiter --version

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/src/app
# Make the entrypoint script executable
RUN chmod +x /usr/src/app/entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
