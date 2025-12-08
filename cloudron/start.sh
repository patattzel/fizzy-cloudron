#!/bin/bash
set -euo pipefail

cd /app/code

export RAILS_ENV="${RAILS_ENV:-production}"
export NODE_ENV="${NODE_ENV:-production}"
export PORT="${PORT:-3000}"
export DATABASE_ADAPTER="${DATABASE_ADAPTER:-mysql}"
export RAILS_SERVE_STATIC_FILES="${RAILS_SERVE_STATIC_FILES:-1}"
export RAILS_LOG_TO_STDOUT="${RAILS_LOG_TO_STDOUT:-1}"
export LOG_LEVEL="${LOG_LEVEL:-info}"
export SOLID_QUEUE_IN_PUMA="${SOLID_QUEUE_IN_PUMA:-1}"
export BUNDLE_WITHOUT="${BUNDLE_WITHOUT:-development:test}"
export BUNDLE_DEPLOYMENT=1
export BUNDLE_PATH="${BUNDLE_PATH:-/usr/local/bundle}"
export HOME="${HOME:-/app/data}"
export BUNDLE_USER_HOME="${BUNDLE_USER_HOME:-${HOME}/.bundle}"
export BUNDLE_APP_CONFIG="${BUNDLE_APP_CONFIG:-${HOME}/.bundle}"
export STORAGE_PATH="${STORAGE_PATH:-/app/data/storage}"
export TMPDIR="${TMPDIR:-/app/data/tmp}"
export BOOTSNAP_CACHE_DIR="${BOOTSNAP_CACHE_DIR:-/app/data/bootsnap-cache}"
export PIDFILE="${PIDFILE:-${TMPDIR}/pids/server.pid}"
APP_USER="${APP_USER:-cloudron}"
SIGNUPS_FLAG_PATH="${SIGNUPS_FLAG_PATH:-/app/data/allow_signups}"

# Map Cloudron-provided MySQL variables into the names Fizzy expects.
if [ -n "${CLOUDRON_MYSQL_HOST:-}" ] && [ -z "${MYSQL_HOST:-}" ]; then
  export MYSQL_HOST="${CLOUDRON_MYSQL_HOST}"
fi
if [ -n "${CLOUDRON_MYSQL_PORT:-}" ] && [ -z "${MYSQL_PORT:-}" ]; then
  export MYSQL_PORT="${CLOUDRON_MYSQL_PORT}"
fi
if [ -n "${CLOUDRON_MYSQL_DATABASE:-}" ] && [ -z "${MYSQL_DATABASE:-}" ]; then
  export MYSQL_DATABASE="${CLOUDRON_MYSQL_DATABASE}"
fi
if [ -n "${CLOUDRON_MYSQL_USERNAME:-}" ] && [ -z "${MYSQL_USER:-}" ]; then
  export MYSQL_USER="${CLOUDRON_MYSQL_USERNAME}"
fi
if [ -n "${CLOUDRON_MYSQL_PASSWORD:-}" ] && [ -z "${MYSQL_PASSWORD:-}" ]; then
  export MYSQL_PASSWORD="${CLOUDRON_MYSQL_PASSWORD}"
fi
if [ -n "${MYSQL_USERNAME:-}" ] && [ -z "${MYSQL_USER:-}" ]; then
  export MYSQL_USER="${MYSQL_USERNAME}"
fi

if [ -n "${CLOUDRON_APP_DOMAIN:-}" ] && [ -z "${APP_HOST:-}" ]; then
  export APP_HOST="${CLOUDRON_APP_DOMAIN}"
fi
if [ -n "${CLOUDRON_APP_ORIGIN:-}" ] && [ -z "${APP_ORIGIN:-}" ]; then
  export APP_ORIGIN="${CLOUDRON_APP_ORIGIN}"
fi
if [ -n "${MAIL_FROM:-}" ] && [ -z "${MAILER_FROM_ADDRESS:-}" ]; then
  export MAILER_FROM_ADDRESS="${MAIL_FROM}"
fi
if [ -n "${CLOUDRON_MAIL_SMTP_USERNAME:-}" ] && [ -z "${MAIL_FROM:-}${MAILER_FROM_ADDRESS:-}" ]; then
  export MAIL_FROM="${CLOUDRON_MAIL_SMTP_USERNAME}"
  export MAILER_FROM_ADDRESS="${MAIL_FROM}"
fi

# Map Cloudron sendmail addon vars into the names our initializer uses.
if [ -n "${CLOUDRON_MAIL_SMTP_SERVER:-}" ] && [ -z "${MAIL_SMTP_SERVER:-}" ]; then
  export MAIL_SMTP_SERVER="${CLOUDRON_MAIL_SMTP_SERVER}"
fi
if [ -n "${CLOUDRON_MAIL_SMTP_PORT:-}" ] && [ -z "${MAIL_SMTP_PORT:-}" ]; then
  export MAIL_SMTP_PORT="${CLOUDRON_MAIL_SMTP_PORT}"
fi
if [ -n "${CLOUDRON_MAIL_SMTP_USERNAME:-}" ] && [ -z "${MAIL_SMTP_USERNAME:-}" ]; then
  export MAIL_SMTP_USERNAME="${CLOUDRON_MAIL_SMTP_USERNAME}"
fi
if [ -n "${CLOUDRON_MAIL_SMTP_PASSWORD:-}" ] && [ -z "${MAIL_SMTP_PASSWORD:-}" ]; then
  export MAIL_SMTP_PASSWORD="${CLOUDRON_MAIL_SMTP_PASSWORD}"
fi

if [ -n "${MAIL_SMTP_SERVER:-}" ] && [ -z "${SMTP_ADDRESS:-}${SMTP_HOST:-}" ]; then
  export SMTP_ADDRESS="${MAIL_SMTP_SERVER}"
fi
if [ -n "${MAIL_SMTP_PORT:-}" ] && [ -z "${SMTP_PORT:-}" ]; then
  export SMTP_PORT="${MAIL_SMTP_PORT}"
fi
if [ -n "${MAIL_SMTP_USERNAME:-}" ] && [ -z "${SMTP_USERNAME:-}" ]; then
  export SMTP_USERNAME="${MAIL_SMTP_USERNAME}"
fi
if [ -n "${MAIL_SMTP_PASSWORD:-}" ] && [ -z "${SMTP_PASSWORD:-}" ]; then
  export SMTP_PASSWORD="${MAIL_SMTP_PASSWORD}"
fi

# Ensure persistent storage is used for uploads, tmp data, logs, and cache.
mkdir -p /app/data "${STORAGE_PATH}" "${TMPDIR}" /app/data/log "${BOOTSNAP_CACHE_DIR}"
mkdir -p "${TMPDIR}/pids" "${STORAGE_PATH}/${RAILS_ENV}/files"
chown -R "${APP_USER}:${APP_USER}" /app/data

# Persist the signup toggle flag so it can be changed outside the container.
if [ ! -f "${SIGNUPS_FLAG_PATH}" ]; then
  echo "${ALLOW_SIGNUPS:-true}" > "${SIGNUPS_FLAG_PATH}"
  chown "${APP_USER}:${APP_USER}" "${SIGNUPS_FLAG_PATH}"
fi

# Persist and generate secrets if they are not provided externally.
if [ -z "${SECRET_KEY_BASE:-}" ]; then
  if [ ! -f /app/data/secret_key_base ]; then
    gosu "${APP_USER}":"${APP_USER}" bundle exec ruby -e "require 'securerandom'; File.write('/app/data/secret_key_base', SecureRandom.hex(64))"
    chown "${APP_USER}:${APP_USER}" /app/data/secret_key_base
  fi
  export SECRET_KEY_BASE="$(cat /app/data/secret_key_base)"
fi

if [ -z "${VAPID_PUBLIC_KEY:-}" ] || [ -z "${VAPID_PRIVATE_KEY:-}" ]; then
  if [ ! -f /app/data/vapid.keys ]; then
    gosu "${APP_USER}":"${APP_USER}" bundle exec ruby -e "require 'web-push'; key = WebPush.generate_key; File.write('/app/data/vapid.keys', \"PUBLIC=#{key.public_key}\nPRIVATE=#{key.private_key}\n\")"
    chown "${APP_USER}:${APP_USER}" /app/data/vapid.keys
  fi
  export VAPID_PUBLIC_KEY="${VAPID_PUBLIC_KEY:-$(grep '^PUBLIC=' /app/data/vapid.keys | cut -d= -f2)}"
  export VAPID_PRIVATE_KEY="${VAPID_PRIVATE_KEY:-$(grep '^PRIVATE=' /app/data/vapid.keys | cut -d= -f2)}"
fi

# Prepare the databases (primary + secondary schemas) and start the app.
gosu "${APP_USER}":"${APP_USER}" bundle exec rails db:prepare
gosu "${APP_USER}":"${APP_USER}" bundle exec rails db:migrate:cable db:migrate:queue db:migrate:cache
exec gosu "${APP_USER}":"${APP_USER}" ./bin/thrust ./bin/rails server -b 0.0.0.0 -p "${PORT}"
