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

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy entrypoint.sh and set permissions
COPY entrypoint.sh /prescriptor-app/
RUN chmod +x /prescriptor-app/entrypoint.sh

# Copy the rest of the application
COPY . .

# Set permissions for the entire app directory
RUN chown -R root:root /prescriptor-app && \
    chmod -R 755 /prescriptor-app

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
