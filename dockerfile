# Dockerfile Chatwoot definitivo para Render
FROM ruby:3.2

# Instala dependencias del sistema necesarias para Rails y Postgres
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    libffi-dev \
    zlib1g-dev \
    nodejs \
    npm \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Instala Yarn usando Corepack (ya viene con Node >=16)
RUN corepack enable

# Directorio de trabajo
WORKDIR /app

# Copia Gemfile y Gemfile.lock primero para usar cache de Docker
COPY Gemfile Gemfile.lock ./

# Instala Bundler y gems
RUN gem install bundler -v 2.4.17
RUN bundle install --jobs=4 --retry=3

# Copia el resto del proyecto
COPY . .

# Instala dependencias Node/Yarn
RUN yarn install --check-files

# Precompila assets de Rails
RUN bundle exec rake assets:precompile

# Expone el puerto usado por Render
EXPOSE 10000

# Comando para iniciar Chatwoot con Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "0.0.0.0", "-p", "10000"]
