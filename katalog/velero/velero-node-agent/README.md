# Velero Node Agent

<!-- <SD-DOCS> -->

## Overview

Velero Node Agent backs up and restores Kubernetes volumes attached to pods from the node file system, using the open-source backup tools [restic][restic] and [Kopia][kopia]. It requires a running Velero instance and is not tied to any specific backend.

## Upstream project

This package is based on the upstream [Velero][velero-page] file system backup feature.

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. It is an internal building block selected automatically when volume backups are enabled. See the [module documentation](../../../README.md) to learn how the Disaster Recovery Module is installed and configured.

<!-- Links -->

[velero-page]: https://velero.io/docs/v1.18/file-system-backup/
[restic]: https://github.com/restic/restic
[kopia]: https://github.com/kopia/kopia

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../../LICENSE)
