# Fizzy on Cloudron

This repo now ships a Cloudron manifest so you can package and run Fizzy on a Cloudron box.

## Prerequisites
- Cloudron CLI installed and logged in (`npm install -g cloudron-cli`)
- A Cloudron instance where you can install custom apps
- MySQL add-on, local storage, and outbound mail are provisioned automatically by Cloudron (see `CloudronManifest.json`)

## Build and install
1. Build the image from the repo root **using the Cloudron Dockerfile**:
   ```sh
   cloudron build --dockerfile Dockerfile.cloudron --image fizzy-cloudron
   ```
2. Install it (choose a subdomain for the app, e.g. `fizzy`):
   ```sh
   cloudron install --image fizzy-cloudron --location fizzy
   ```
3. Cloudron will prompt for the installation location; accept the defaults for MySQL and mail.

The container listens on port 3000 (`httpPort` in the manifest) and uses `/up` for health checks.

## Runtime configuration
- Secrets and keys:
  - `SECRET_KEY_BASE` and VAPID keys are generated and persisted under `/app/data` on first boot if you don't supply them. You can also pre-set `SECRET_KEY_BASE` in the Cloudron UI if you prefer.
  - Set `MAILER_FROM_ADDRESS` if you want a specific from-address (falls back to Cloudron's `MAIL_FROM`).
- Host/URLs: The app auto-configures URL defaults from `CLOUDRON_APP_DOMAIN`/`CLOUDRON_APP_ORIGIN`. You can override with `APP_HOST`/`APP_ORIGIN` in the Cloudron dashboard if desired.
- Database: The start script maps the MySQL add-on environment into `MYSQL_*` variables Fizzy expects and defaults all schemas to the single database Cloudron provisions.
- Storage: uploads/logs/tmp live in `/app/data`; the start script symlinks `storage`, `tmp`, and `log` there.
- Background jobs: `SOLID_QUEUE_IN_PUMA=1` is enabled by default so Solid Queue workers run alongside Puma.

After install, visit the chosen location (e.g. `https://fizzy.your-cloudron.tld`) and sign up/log in as usual.
