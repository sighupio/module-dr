# Grafana Dashboards for Velero

Grafana Dashboard is taken from the official one maintained by the Velero team:
<https://grafana.com/grafana/dashboards/16829-kubernetes-tanzu-velero/>

Current version in repo: revision 5 (2023-09-14, the latest available upstream).

To update:

1. Download the new revision:

```bash
curl -sL -o velero.json https://grafana.com/api/dashboards/16829/revisions/<N>/download
```

2. Set `"id": null`.

3. Simplify the title:

```bash
sed -i -e 's#Kubernetes/Tanzu/Velero#Velero#g' velero.json
```
