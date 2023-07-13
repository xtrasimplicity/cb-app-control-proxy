FROM nginx:latest
COPY docker-entrypoint.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/docker-entrypoint.sh

