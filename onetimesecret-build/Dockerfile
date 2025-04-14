FROM ruby:3.1-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    git \
    libffi-dev \ 
    libyaml-dev \    
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/onetimesecret/onetimesecret.git .

RUN gem install bundler -v '< 2.0' && \
    bundle install

RUN mkdir -p /app/etc

# configuration files will be mounted as ConfigMaps

EXPOSE 7143

CMD ["bundle", "exec", "thin", "start", "-e", "production", "-p", "7143", "-R", "config.ru"]