# ----------------------------
# Dockerfile Chatwoot definitivo para Render
# ----------------------------

# Usamos la imagen oficial de Chatwoot que ya trae Ruby, Node, Yarn y todas las librerías
FROM chatwoot/chatwoot:latest

# Directorio de trabajo
WORKDIR /app

# Copia tu código (si hiciste un fork o modificaciones)
COPY . .

# Exponer puerto que Render usará
EXPOSE 10000

# Comando para iniciar Chatwoot con Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "0.0.0.0", "-p", "10000"]
