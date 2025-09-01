# Velero Node Agent

Velero supports backing up and restoring Kubernetes volumes attached to pods from the file system of the modules.
The data movement is fulfilled by using [restic](https://github.com/restic/restic) and [Kopia](https://github.com/kopia/kopia), both are Open Source backup tools.
This support is considered beta quality due to a list of [limitations](https://velero.io/docs/v1.12/file-system-backup/#limitations).


## Image repository and tag

- Velero Node Agent image: `velero/velero:v1.16.2`
- Velero Node Agent repository: [https://github.com/vmware-tanzu/velero](https://github.com/vmware-tanzu/velero).


## Requirements

This deployment requires to have previously deployed a velero instance. Choose one option:

- [velero on premises](../velero-on-prem)
- [velero AWS](../velero-aws)
- [velero GCP](../velero-gcp)
- [velero Azure](../velero-azure)


## Deployment

You can deploy Velero AWS by running the following command in the root of this project:

```bash
$ kustomize build | kubectl apply -f -
# omitted output
```

## License

For license details please see [LICENSE](../../../LICENSE)
