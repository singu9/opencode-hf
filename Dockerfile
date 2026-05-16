FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install core dependencies, Node.js (via NodeSource for v18+ support), and ttyd
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    build-essential \
    ttyd \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 1. Install OpenCode globally via its official Node package manager registry
RUN npm install -g opencode-ai

# 2. Verify that npm registered the command globally (This creates /usr/bin/opencode or /usr/local/bin/opencode)
RUN opencode --version

# Create a project workspace directory
WORKDIR /workspace

# Hugging Face Spaces run on port 7860
EXPOSE 7860

# Expose OpenCode globally over the web terminal interface
# ttyd will call 'opencode' safely out of npm's globally registered bin PATH
CMD ["ttyd", "-p", "7860", "-W", "bash", "-c", "opencode"]
