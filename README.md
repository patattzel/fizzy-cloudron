# Fizzy on Cloudron

This repo is configured to run Fizzy as a Cloudron app using the supplied `Dockerfile.cloudron`, `CloudronManifest.json`, and `cloudron/start.sh`.

## Build & install on Cloudron

The CLI option `cloudron build` with a custom Dockerfile is not available everywhere, so use standard Docker build/push and then install/update:

1) Build and push (bump `version` in `CloudronManifest.json` when updating):
```sh
docker build -f Dockerfile.cloudron -t <registry>/fizzy-cloudron:<tag> .
docker push <registry>/fizzy-cloudron:<tag>
```

2) Install or update on your Cloudron:
```sh
cloudron install --image <registry>/fizzy-cloudron:<tag> --app <your-domain>
cloudron update  --image <registry>/fizzy-cloudron:<new-tag> --app <your-domain>
```

If you prefer the Cloudron builder flow, see the Cloudron packaging tutorial for the `cloudron build`/`cloudron update` workflow.

## Required/optional environment variables

Set these in the Cloudron app settings:

- `APP_HOST` / `APP_ORIGIN` are auto-filled by Cloudron, no change needed.
- Database comes from the Cloudron MySQL addon (auto-mapped).
- Mail (Cloudron mail addon is auto-mapped):
  - `MAIL_SMTP_SERVER`, `MAIL_SMTP_PORT`, `MAIL_SMTP_USERNAME`, `MAIL_SMTP_PASSWORD` (mapped from Cloudron sendmail vars)
  - `MAIL_FROM` or `MAILER_FROM_ADDRESS` (mapped from `CLOUDRON_MAIL_FROM` if set; must match your allowed sender)
  - `MAIL_FROM_DISPLAY_NAME` (mapped from `CLOUDRON_MAIL_FROM_DISPLAY_NAME` if set)
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

Disabling signups only blocks public self-signup. Invite/join flows and magic-link login for existing users continue to work.

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

You are welcome -- and encouraged -- to modify Fizzy to your liking.
Please see our [Development guide](docs/development.md) for how to get Fizzy set up for local development.

## Contributing

We welcome contributions! Please read our [style guide](STYLE.md) before submitting code.

## License

Fizzy is released under the [O'Saasy License](LICENSE.md).
