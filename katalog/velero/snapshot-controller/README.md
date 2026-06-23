# Snapshot Controller

<!-- <SD-DOCS> -->

## Overview

The Snapshot Controller enables [CSI Snapshot Data Movement][csi-data-movement] support, allowing Velero to move CSI snapshot data to a backup storage location in a consistent manner. It requires a CSI driver capable of volume snapshots at the v1 API level installed on the underlying infrastructure.

## Upstream project

This package is based on the upstream [CSI external-snapshotter][external-snapshotter].

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. It is an internal building block selected automatically when CSI Snapshot Data Movement is enabled. See the [module documentation](../../../README.md) to learn how the Disaster Recovery Module is installed and configured.

<!-- Links -->

[csi-data-movement]: https://velero.io/docs/main/csi-snapshot-data-movement/
[external-snapshotter]: https://github.com/kubernetes-csi/external-snapshotter

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../../LICENSE)
