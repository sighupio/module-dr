# Snapshot Controller for Velero CSI Snapshot Data Movement

This component [`snapshot-controller`](../../katalog/velero/snapshot-controller/) has been added to allow the volumes data to be backed up to a pre-defined backup storage in a consistent manner, following the [CSI Snapshot Data Movement design](https://velero.io/docs/main/csi-snapshot-data-movement/).

## Image repository and tag

- Snapshot Controller image: `registry.k8s.io/sig-storage/snapshot-controller:v8.2.0`
- Snapshot Controller repository:
[github.com/kubernetes-csi/external-snapshotter](https://github.com/kubernetes-csi/external-snapshotter).

## Requirements

This deployment of the `snapshot-controller`, in order to enable **CSI Snapshot Data Movement* support, requires that the cluster meets the following prerequisites:

- it has a running **CSI Driver** capable of support volume snapshots at the [v1 API level](https://kubernetes.io/blog/2020/12/10/kubernetes-1.20-volume-snapshot-moves-to-ga/).
- supports the [Kubernetes MountPropagation](https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation) feature.

As default behaviour, a `VolumeSnapshotClass` can be created for a particular driver, adding a label on it to indicate that it is the default **VolumeSnapshotClass** for that driver:

Example `VolumeSnapshotClass`:
```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: velero-snapclass
  labels:
    velero.io/csi-volumesnapshot-class: "true"
driver: hostpath.csi.k8s.io
deletionPolicy: Retain
```

In this way, the CSI snapshot will be applied for all the volumes backed by the **CSI Driver**.

Example of `PersistentVolumeClaim` that uses the **CSI Driver storage class**:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
  namespace: example-namespace
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: csi-hostpath-sc # CSI Driver StorageClass
  resources:
    requests:
      storage: 100Mi
```

Other implementation choices are available for implementing the CSI snapshot, consider to take a look at the [documentation](https://velero.io/docs/main/csi/).

## Deployment

You can deploy the `snapshot-controller` enabling [CSI Data Movement support](https://velero.io/docs/main/csi-snapshot-data-movement/) by running the following command from the root of the [`snapshot-controller` module](../snapshot-controller/):

```bash
$ kustomize build | kubectl apply -f -
# omitted output
```

## License

For license details please see [LICENSE](../../../LICENSE)
