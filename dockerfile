# Dockerfile Chatwoot para Render
FROM chatwoot/chatwoot:latest

# Directorio de trabajo
WORKDIR /app

# Copia el código del fork / repo
COPY . .

# Instala gems de tu proyecto
RUN bundle config set without 'development test'
RUN bundle install --jobs=4 --retry=3

# Instala dependencias Node/Yarn si hay frontend changes
RUN yarn install --check-files

# Precompila assets
RUN bundle exec rake assets:precompile

# Exponer puerto que Render usará
EXPOSE 10000

# Arrancar Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "0.0.0.0", "-p", "10000"]
