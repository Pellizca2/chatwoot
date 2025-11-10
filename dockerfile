# Dockerfile Chatwoot definitivo para Render
FROM ruby:3.2-slim

# Variables de entorno para que apt no pregunte nada
ENV DEBIAN_FRONTEND=noninteractive

# Instala todas las dependencias necesarias para Rails, Postgres y Chatwoot
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    git \
    curl \
    libpq-dev \
    postgresql-client \
    libffi-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    nodejs \
    npm \
    yarn \
    imagemagick \
    ffmpeg \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Habilita Corepack para Yarn
RUN corepack enable

# Directorio de trabajo
WORKDIR /app

# Copia Gemfile y Gemfile.lock primero
COPY Gemfile Gemfile.lock ./

# Instala Bundler y Gems
RUN gem install bundler -v 2.4.17
RUN bundle config set without 'development test'
RUN bundle install --jobs=4 --retry=3

# Copia el resto del proyecto
COPY . .

# Instala dependencias Node/Yarn
RUN yarn install --check-files

# Precompila assets de Rails
RUN bundle exec rake assets:precompile

# Expone el puerto que Render usará
EXPOSE 10000

# Comando para iniciar Chatwoot con Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "0.0.0.0", "-p", "10000"]
