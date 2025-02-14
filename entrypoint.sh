#!/bin/bash
set -e

# Remove any existing server.pid
rm -f tmp/pids/server.pid

bundle install

# Precompile assets
bundle exec rails assets:precompile

# Start Tailwind watching and Rails server
bundle exec rails tailwindcss:watch & 
bundle exec rails server -p 3000 -b '0.0.0.0' -u puma

# Execute any other commands
exec "$@"
