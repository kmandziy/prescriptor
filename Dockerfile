FROM ruby:3.3.0-slim

# Install essential dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client \
    git \
    curl

# Install node and yarn
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# Set working directory
WORKDIR /prescriptor-app

# Create directories for volume mounting
RUN mkdir -p /usr/local/bundle \
    && mkdir -p /prescriptor-app/tmp \
    && chmod -R 777 /usr/local/bundle \
    && chmod -R 777 /prescriptor-app/tmp

# Set permissions for the app directory
RUN chmod -R 777 /prescriptor-app

# Set default command
CMD ["rails", "server", "-b", "0.0.0.0"]
