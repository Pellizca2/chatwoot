# Dockerfile Chatwoot para Render
FROM chatwoot/chatwoot:latest

# Directorio de trabajo
WORKDIR /app

# Copia tu código
COPY . .

# Habilita Yarn usando Corepack (incluido en Node.js >=16)
RUN corepack enable

# Instala gems de Ruby
RUN bundle config set without 'development test'
RUN bundle install --jobs=4 --retry=3

# Instala dependencias Node/Yarn
RUN yarn install --check-files

# Precompila assets de Rails
RUN bundle exec rake assets:precompile

# Expone el puerto usado por Render
EXPOSE 10000

# Comando para iniciar Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "0.0.0.0", "-p", "10000"]
