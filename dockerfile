# ----------------------------
# Chatwoot Dockerfile para Render
# ----------------------------

# Usa la versión oficial de Ruby
FROM ruby:3.2

# Instala dependencias del sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    npm \
    postgresql-client \
    yarn \
    git \
    curl \
    libpq-dev \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Directorio de trabajo
WORKDIR /app

# Copia todo el código al contenedor
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
