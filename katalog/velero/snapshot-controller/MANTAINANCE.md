# Snapshot Controller Velero Package Maintenance Guide

To update the Snapshot Controller Velero package, follow the next steps:

- Get the upstream manifests running:
    ```bash
    mise run upgrade
    ```

- Update CRDs in [`/katalog/velero/snapshot-controller/crds.yaml`](./crds.yaml)
- Update [`rbac.yaml`](rbac.yaml) and [`deployment.yaml`](./deployment.yaml) porting the necessary changes
- Update the image tags
- Sync the image to our registry
