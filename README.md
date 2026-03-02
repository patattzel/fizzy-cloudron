# Fizzy on Cloudron

This repository packages Basecamp's Fizzy for Cloudron and now targets the Cloudron 9.1 community app flow.

## Cloudron package files

- `CloudronManifest.json` defines the package metadata Cloudron reads.
- `CloudronVersions.json` is the release index for installable community-package versions.
- `Dockerfile.cloudron` builds the Cloudron-specific container image.
- `cloudron/start.sh` adapts the Cloudron runtime environment and boots the Rails app.

Cloudron recommends keeping package metadata in a dedicated public repository. This package stays in the application repo for now, but follows the same metadata model.

## Install on Cloudron 9.1+

The primary supported path is the Cloudron 9.1 community app flow.

In the Cloudron dashboard, open Community apps and enter:

```text
https://raw.githubusercontent.com/patattzel/fizzy-cloudron/refs/heads/main/CloudronVersions.json
```

Cloudron reads the package metadata from that public `CloudronVersions.json` URL and offers updates automatically.

For manual fallback installs, you can still install the stable package image directly:

```sh
cloudron install --image ghcr.io/patattzel/fizzy-cloudron:stable --location fizzy
```

## Maintainer release flow

1. Update `CloudronManifest.json` and bump the package `version`.
2. Add a matching immutable entry in `CloudronVersions.json`.
3. Push the commit to `main`.
4. Push a matching Git tag in the form `v<version>` to publish the immutable Cloudron image tag and refresh `stable`.

The existing GitHub CI workflows remain useful for the Rails app. Only `.github/workflows/publish-image.yml` is Cloudron-specific, and it now publishes the Cloudron package image from `Dockerfile.cloudron`.

## Runtime notes

- Cloudron provides MySQL, local storage, and sendmail through add-ons.
- Persistent application data lives under `/app/data`.
- `cloudron/start.sh` maps Cloudron environment variables into the settings Fizzy expects.
- Secrets such as `SECRET_KEY_BASE` and VAPID keys are generated under `/app/data` on first boot when not provided.

See [the Cloudron guide](docs/cloudron.md) for installation details, runtime behavior, and release maintenance.
