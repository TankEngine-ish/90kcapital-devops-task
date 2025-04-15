FROM ruby:3.1-bullseye

WORKDIR /app


RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    git \
    libffi-dev \ 
    libyaml-dev \    
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/onetimesecret/onetimesecret.git .


RUN gem install bundler
RUN bundle install

EXPOSE 7143


CMD ["bundle", "exec", "thin", "start", "-e", "development", "-p", "7143", "-R", "config.ru"]