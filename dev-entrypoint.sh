#!/bin/sh

set -e

echo "Environment: $RAILS_ENV"

# Remove pre-existing puma server.pid
rm -f $APP_PATH/tmp/pids/server.pid

bundle install --jobs=3 --retry=3

# Create database and run migrations if needed (idempotent)
bundle exec rails db:prepare 2>/dev/null || true

# run passed commands
bundle exec ${@}
