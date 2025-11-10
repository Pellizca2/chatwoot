# ----------------------------
# Dockerfile Chatwoot para Render (Node + Yarn sin apt-key)
# ----------------------------

FROM ruby:3.2

# Instala dependencias del sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Instala Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Activa Yarn usando Corepack (ya viene con Node.js >=16)
RUN corepack enable

# Directorio de trabajo
WORKDIR /app

# Copia todo el código
COPY . .

# Instala dependencias Ruby y Node
RUN gem install bundler && bundle install
RUN yarn install --check-files

# Precompila assets de Rails
RUN bundle exec rake assets:precompile

# Exponer puerto usado por Render
EXPOSE 10000

# Comando para iniciar Chatwoot con Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "0.0.0.0", "-p", "10000"]
