FROM ruby:3.2-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias del sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    libffi-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    imagemagick \
    ffmpeg \
    libcurl4-openssl-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libgmp-dev \
    make \
    && rm -rf /var/lib/apt/lists/*

# Instala Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Yarn desde npm
RUN npm install -g yarn

WORKDIR /app

# Copia Gemfile y Gemfile.lock primero
COPY Gemfile Gemfile.lock ./

# Bundler + gems
RUN gem install bundler -v 2.4.17
RUN bundle config set without 'development test'
RUN bundle install --jobs=4 --retry=3

# Copia el resto del proyecto
COPY . .

# Instala dependencias Node/Yarn
RUN yarn install --check-files

# Precompila assets de Rails
RUN bundle exec rake assets:precompile

EXPOSE 10000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "0.0.0.0", "-p", "10000"]
