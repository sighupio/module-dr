# Velero Package Maintenance Guide

To update the Velero package, follow the next steps:
- Update the Velero CLI to your target version
- Get the upstream manifest with
```bash
velero install --namespace kube-system --provider aws --no-secret --bucket my-bucket --dry-run -o yaml --plugins velero/velero-plugin-for-aws:<tag> --use-node-agent > orig.yaml
```
- Update CRDs in [`/katalog/velero/velero-base/crds.yaml`](./velero-base/crds.yaml) with: `velero install --crds-only --dry-run -o yaml > crds.yaml`
- Port the needed changes
- Update the images tags
- Sync the image to our registry

## Customizations
- The package has been split in three Kustomize bases:
  - [`velero-base`](./velero-base)
  - [`velero-node-agent`](./velero-node-agent)
  - [`velero-schedules`](./velero-schedules)

  and four Kustomize overlays:
  - [`velero-aws`](./velero-aws)
  - [`velero-azure`](./velero-azure)
  - [`velero-gcp`](./velero-gcp)
  - [`velero-on-prem`](./velero-on-prem)

  - The [`snapshot-controller`](./snapshot-controller/) package is needed to enable [CSI Snapshot Data Movement](https://velero.io/docs/main/csi-snapshot-data-movement/) support. See its dedicated maintenance guide at [`snapshot-controller/MANTAINANCE.md`](./snapshot-controller/MANTAINANCE.md).

- Split the manifests into different files
- Velero is deployed in the `kube-system` namespace instead of `velero`
- Added `securityContext` to Velero `Deployment`
- Removed Prometheus annotations from Velero `Deployment`
- Added a `Service` and a `ServiceMonitor` for monitoring
- Add `--features=EnableCSI` to enable the use of the underlying *CSI Driver* for Velero.
- Change `--uploader-type=restic` to `--uploader-type=kopia`, in order to use [kopia](https://github.com/kopia/kopia/) for Data Movement.
- Add the `HOME` environment variable and a volume mount as a workaround for [this issue](https://github.com/vmware-tanzu/velero/issues/8067), which is due to the `runAsUser` set in the `securityContext` of the [Velero deployment](../velero-base/deployment.yaml)
- Added `--client-qps=75.0` and `--client-burst=100` to the Velero server `args` to tune API server request rate limits.
- Added `--node-agent-configmap=node-agent-config` to the node-agent `DaemonSet` to point it at the configuration `ConfigMap`.
- Added a `node-agent-config` `ConfigMap` (in `velero-node-agent`) to configure the node-agent; currently sets `prepareQueueLength` to control the number of concurrent backup prepare operations.
