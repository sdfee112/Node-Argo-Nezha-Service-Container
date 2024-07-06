FROM debian

WORKDIR /dashboard

# Install required packages
RUN apt-get update && \
    apt-get -y install openssh-server wget iproute2 vim git cron unzip supervisor nginx sqlite3 && \
    # Install Node.js from NodeSource
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    # Configure Git settings
    git config --global core.bigFileThreshold 1k && \
    git config --global core.compression 0 && \
    git config --global advice.detachedHead false && \
    git config --global pack.threads 1 && \
    git config --global pack.windowMemory 50m && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Create entrypoint script
    echo "#!/usr/bin/env bash\n\n\
bash <(wget -qO- https://raw.githubusercontent.com/sdfee112/Node-Argo-Nezha-Service-Container/main/init.sh)" > entrypoint.sh && \
    chmod +x entrypoint.sh
COPY package*.json ./
COPY index.js ./
# Install Node.js dependencies
RUN npm install
# Set the entrypoint
ENTRYPOINT ["./entrypoint.sh"]
