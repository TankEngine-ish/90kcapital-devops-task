FROM ruby:3.1-bookworm

WORKDIR /app


RUN apt-get update && apt-get install -y \
    git \
    redis-server \
    build-essential \
    libyaml-dev \
    libffi-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*


RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g pnpm@latest


RUN git clone https://github.com/onetimesecret/onetimesecret.git .


RUN git rev-parse --short HEAD > .commit_hash.txt

RUN cp --preserve --no-clobber ./etc/config.example.yaml ./etc/config.yaml && \
    sed -i 's/host: 127.0.0.1/host: redis.redis.svc.cluster.local/g' ./etc/config.yaml && \
    sed -i 's/password: secret/password: redis/g' ./etc/config.yaml && \
    cat ./etc/config.yaml


RUN gem install bundler
RUN bundle config set --local without 'development test'
RUN bundle update --bundler
RUN bundle install


RUN pnpm install --frozen-lockfile

EXPOSE 7143


ENV RACK_ENV=development
ENV RAILS_ENV=development

CMD ["bundle", "exec", "thin", "start", "-e", "development", "-p", "7143", "-R", "config.ru"]