# Velero Base

<!-- <SD-DOCS> -->

## Overview

Velero Base contains the common Velero components (CRDs, base deployment, RBAC, manifest backup schedule and the metrics service and ServiceMonitor) shared by every backend. It does not provide a working backup setup on its own; the backend-specific packages build on top of it.

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. It is an internal building block selected automatically based on the chosen backend and provider. See the [module documentation](../../../README.md) to learn how the Disaster Recovery Module is installed and configured.

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../../LICENSE)
