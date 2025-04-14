FROM ruby:2.7-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone the OneTimeSecret repository
RUN git clone https://github.com/onetimesecret/onetimesecret.git .

# Install bundler and dependencies
RUN gem install bundler -v '< 2.0' && \
    bundle install

# Create config directory
RUN mkdir -p /app/etc

# Configuration files will be mounted as ConfigMaps

EXPOSE 7143

# Start OneTimeSecret
CMD ["bundle", "exec", "thin", "start", "-e", "production", "-p", "7143", "-R", "config.ru"]