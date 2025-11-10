# ----------------------------
# Chatwoot Dockerfile para Render
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

# Instala Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# Directorio de trabajo
WORKDIR /app

# Copia todos los archivos del repo
COPY . .

# Instala dependencias Ruby y Node
RUN gem install bundler && bundle install
RUN yarn install --check-files

# Precompila assets
RUN bundle exec rake assets:precompile

# Exponer puerto usado por Render
EXPOSE 10000

# Comando para iniciar Chatwoot con Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "0.0.0.0", "-p", "10000"]
