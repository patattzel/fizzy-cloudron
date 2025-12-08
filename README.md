# Fizzy on Cloudron

This repo is configured to run Fizzy as a Cloudron app using the supplied `Dockerfile.cloudron`, `CloudronManifest.json`, and `cloudron/start.sh`.

## Build & install on Cloudron

1. Build the image (bump `version` in `CloudronManifest.json` when updating):
   ```sh
   cloudron build --set-version <x.y.z> --dockerfile Dockerfile.cloudron
   ```
2. Install or update:
   ```sh
   cloudron install --app <your-domain>   # first install
   cloudron update  --app <your-domain>   # subsequent updates
   ```
   Alternatively push to a registry and `cloudron install --image <registry>/fizzy-cloudron:<tag>`.

## Required/optional environment variables

Set these in the Cloudron app settings:

- `APP_HOST` / `APP_ORIGIN` are auto-filled by Cloudron, no change needed.
- Database comes from the Cloudron MySQL addon (auto-mapped).
- Mail (Cloudron mail addon is auto-mapped):
  - `MAIL_SMTP_SERVER`, `MAIL_SMTP_PORT`, `MAIL_SMTP_USERNAME`, `MAIL_SMTP_PASSWORD`
  - `MAIL_FROM` or `MAILER_FROM_ADDRESS` (must match your allowed sender)
  - `SUPPORT_EMAIL` (mailto in UI/emails, defaults to `MAIL_FROM`)
- Push notifications: `VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY` (auto-generated on first run if missing).
- Logging: `LOG_LEVEL` (default `info`).
- Signup toggle: `ALLOW_SIGNUPS` (`true`/`false`, default `true`). See “Disable signups” below.

## Persistent data

Cloudron mounts `/app/data` and the start script symlinks:
- `log` → `/app/data/log`
- `tmp` → `/app/data/tmp`
- `storage` (Active Storage) → `/app/data/storage`
- Secrets in `/app/data/secret_key_base` and `/app/data/vapid.keys`
- Signup flag at `/app/data/allow_signups`

## Disable/enable signups

Signup routes are gated by a persisted flag file:
- To disable: `echo false > /app/data/allow_signups && cloudron restart --app <domain>`
- To enable:  `echo true  > /app/data/allow_signups && cloudron restart --app <domain>`

`ALLOW_SIGNUPS` env (default `true`) seeds the flag on first boot; afterwards the file takes precedence.

## First staff user

The first created identity is automatically promoted to `staff`. Subsequent staff can be set via Rails console/runner if needed.

## Where uploads live

Active Storage uses the local service pointing at `/app/data/storage/<environment>/files`.

## Developing locally

Standard Rails workflow:
```sh
bin/setup        # install deps, db setup
bin/dev          # run app at http://fizzy.localhost:3006
bin/rails test   # run tests
```

SQLite is default; MySQL supported via `DATABASE_ADAPTER=mysql`.

## License

Fizzy is released under the [O'Saasy License](LICENSE.md).
