# Fizzy on Cloudron

This repository packages Fizzy as a Cloudron 9.1 community app.

Cloudron's current publishing guidance for third-party packages is:

- Do not expect publication in the official Cloudron App Store.
- Keep package metadata in a public GitHub repository.
- Publish installable versions through `CloudronVersions.json`.

This repository keeps the package metadata alongside the application code, but uses the same community-package format.

## Package layout

- `CloudronManifest.json`: current package metadata and the moving `stable` image reference.
- `CloudronVersions.json`: append-only release index with installable immutable versions.
- `Dockerfile.cloudron`: Cloudron-specific image build.
- `cloudron/start.sh`: runtime bootstrap for Cloudron.

The package currently targets Cloudron `9.1.0` and newer.

## Install

The primary supported installation path is the Cloudron 9.1 community app flow:

1. In the Cloudron dashboard, open Community apps.
2. Enter this public `CloudronVersions.json` URL:

```text
https://raw.githubusercontent.com/patattzel/fizzy-cloudron/refs/heads/main/CloudronVersions.json
```

3. Let Cloudron read the version catalog and install the latest published version.

This package is not documented as an official Cloudron App Store app.

## Manual fallback

If you need a direct image install instead of the community package source flow, use the moving stable image:

```sh
cloudron install --image ghcr.io/patattzel/fizzy-cloudron:stable --location fizzy
```

For direct image updates:

```sh
cloudron update --image ghcr.io/patattzel/fizzy-cloudron:stable --app fizzy.your-cloudron.tld
```

The manual image flow is secondary. The authoritative package metadata remains `CloudronManifest.json` plus `CloudronVersions.json`.
Use `stable` or an explicit package version such as `ghcr.io/patattzel/fizzy-cloudron:1.2.4`. Do not use `latest`.

## Runtime configuration

### Networking

- The container listens on port `3000`.
- The package health check path is `/up`.
- `APP_HOST` defaults from `CLOUDRON_APP_DOMAIN`.
- `APP_ORIGIN` defaults from `CLOUDRON_APP_ORIGIN`.

### Database

`cloudron/start.sh` maps Cloudron's MySQL add-on variables into the names Fizzy expects:

- `CLOUDRON_MYSQL_HOST` -> `MYSQL_HOST`
- `CLOUDRON_MYSQL_PORT` -> `MYSQL_PORT`
- `CLOUDRON_MYSQL_DATABASE` -> `MYSQL_DATABASE`
- `CLOUDRON_MYSQL_USERNAME` -> `MYSQL_USER`
- `CLOUDRON_MYSQL_PASSWORD` -> `MYSQL_PASSWORD`

The entrypoint runs:

- `bundle exec rails db:prepare`
- `bundle exec rails db:migrate:cable db:migrate:queue db:migrate:cache`

### Mail

Cloudron sendmail values are mapped into Fizzy mail settings:

- `CLOUDRON_MAIL_SMTP_SERVER` -> `MAIL_SMTP_SERVER`
- `CLOUDRON_MAIL_SMTP_PORT` -> `MAIL_SMTP_PORT`
- `CLOUDRON_MAIL_SMTP_USERNAME` -> `MAIL_SMTP_USERNAME`
- `CLOUDRON_MAIL_SMTP_PASSWORD` -> `MAIL_SMTP_PASSWORD`
- `CLOUDRON_MAIL_FROM` -> `MAIL_FROM` / `MAILER_FROM_ADDRESS`
- `CLOUDRON_MAIL_FROM_DISPLAY_NAME` -> `MAIL_FROM_DISPLAY_NAME`

If SMTP is configured, `config/initializers/cloudron.rb` switches Action Mailer to SMTP automatically.

### Persistent data

Cloudron mounts `/app/data`. The container keeps runtime state there:

- `storage` -> `/app/data/storage`
- `tmp` -> `/app/data/tmp`
- `log` -> `/app/data/log`
- `SECRET_KEY_BASE` in `/app/data/secret_key_base`
- VAPID keys in `/app/data/vapid.keys`
- signup toggle in `/app/data/allow_signups`

### Secrets and first boot

- `SECRET_KEY_BASE` is generated on first boot if not set.
- `VAPID_PUBLIC_KEY` and `VAPID_PRIVATE_KEY` are generated on first boot if not set.
- `SOLID_QUEUE_IN_PUMA=1` is enabled by default so background jobs run with Puma.

### Signup toggle

`ALLOW_SIGNUPS` seeds `/app/data/allow_signups` on the first boot only.

To change it later:

```sh
echo false > /app/data/allow_signups
cloudron restart --app fizzy.your-cloudron.tld
```

Set it back to `true` to re-enable public signups.

## Maintainer release process

Community package releases are driven by both metadata files.

1. Update `CloudronManifest.json`.
2. Bump `version`.
3. Keep `dockerImage` set to `ghcr.io/patattzel/fizzy-cloudron:stable`.
4. Add or update the matching immutable version entry in `CloudronVersions.json`.
5. Set the version entry's embedded manifest `dockerImage` to `ghcr.io/patattzel/fizzy-cloudron:<version>`.
6. Commit the changes.
7. Push to `main` to validate metadata and publish the moving `stable` image.
8. Push a matching Git tag `v<version>` to publish the immutable version tag and refresh `stable`.

The publish automation lives in [`../.github/workflows/publish-image.yml`](../.github/workflows/publish-image.yml). The Rails CI workflows remain unchanged because they still validate the underlying application code.

## Local development

Standard Rails development remains unchanged:

```sh
bin/setup
bin/dev
bin/rails test
```
