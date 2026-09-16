# Disaster recovery Core Module Release v3.5.0

Welcome to the latest release of the `DR` module of [`SIGHUP Distribution`](https://github.com/sighupio/distribution) maintained by team SIGHUP by ReeVo.

This latest release adds support for K8S v1.36 and upgrades the components in the module to their latest stable release.

## Component Images 🚢

| Component                           | Supported Version                                                                                | Previous Version |
|-------------------------------------|--------------------------------------------------------------------------------------------------|------------------|
| `velero`                            | [`v1.18.1`](https://github.com/velero-io/velero/releases/tag/v1.18.1)                            | `No Update`      |
| `velero-plugin-for-aws`             | [`v1.14.2`](https://github.com/velero-io/velero-plugin-for-aws/releases/tag/v1.14.2)             | `v1.14.1`        |
| `velero-plugin-for-microsoft-azure` | [`v1.14.1`](https://github.com/velero-io/velero-plugin-for-microsoft-azure/releases/tag/v1.14.1) | `No Update`      |
| `velero-plugin-for-gcp`             | [`v1.14.1`](https://github.com/velero-io/velero-plugin-for-gcp/releases/tag/v1.14.1)             | `No Update`      |
| `snapshot-controller`               | [`v8.6.0`](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v8.6.0)           | `v8.4.0`         |
| `minio` (on-prem)                   | `RELEASE.2026-05-20T23-44-52Z-chainguard`                                                        | `No Update`      |

> Please refer to the individual release notes to get detailed information on each release.

## Features 💥

- Add support for Kubernetes 1.36
- Update velero-plugin-for-aws to v1.14.2: support for specifying the KMS key for EBS volume restoration

## Breaking Changes 💔

TBD

## Upgrade Guide 🦮

To upgrade this module from v3.4.0 to v3.5.0, you need to download this new version and then:

1. Upgrade Velero CRDs
```bash
# Upgrade CRDs
kubectl apply -f katalog/velero/velero-base/crds.yaml
```

2. Upgrade Velero
```yaml
# Upgrade Velero
kustomize build katalog/velero/velero-aws | kubectl apply -f -
# Or
kustomize build katalog/velero/velero-gcp | kubectl apply -f -
# Or
kustomize build katalog/velero/velero-azure | kubectl apply -f -
# Or, if the cluster is on-premise remove the minio-setup job first
kubectl delete job -n kube-system minio-setup
kustomize build katalog/velero/velero-on-prem | kubectl apply -f -
```

3. *(Optional) Install/upgrade the snapshot controller*:
   if you want to enable VolumeSnapshots as backups, you can install and/or upgrade the [`snapshot-controller`](../../katalog/velero/snapshot-controller/) package.

```yaml
# Install snapshot-controller
kustomize build katalog/velero/snapshot-controller | kubectl apply -f -
```
