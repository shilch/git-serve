FROM openresty/openresty:1.15.8.2-6-alpine

# Install dependencies
RUN apk update
RUN apk add git

# Copy over shell scripts
COPY scripts/ /var/scripts/
RUN chmod -R 775 /var/scripts/

# Configure nginx
COPY nginx/default.conf /etc/nginx/conf.d/

ENTRYPOINT ["/var/scripts/entrypoint.sh"]
