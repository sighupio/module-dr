# Velero

<!-- <SD-DOCS> -->

## Overview

Velero *(formerly Heptio Ark)* backs up and restores Kubernetes cluster resources and persistent volumes. It lets you take backups of your cluster and restore them in case of loss, migrate cluster resources to other clusters, and replicate your production cluster to development and testing clusters. It can run with a cloud provider or on-premises. This package bundles the Velero server together with the components that support the different storage backends and providers.

## Upstream project

This package is based on the upstream [Velero][velero-page].

## Deployment

This package is deployed as part of **Disaster Recovery Module** when you create a cluster with `furyctl`. You can customize it under `spec.distribution.modules.dr.velero` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[velero-page]: https://velero.io
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesdr
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesdr
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesdr

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)
