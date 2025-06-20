# Use official WordPress image as base
FROM wordpress:latest

# Maintainer info
LABEL maintainer="sonicasonawane@gmail.com"

# Set working directory
WORKDIR /var/www/html

# Expose port
EXPOSE 80

# Health check (optional)
HEALTHCHECK --interval=30s CMD curl --fail http://localhost || exit 1

