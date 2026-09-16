# Grafana Dahsboards for Velero

Grafana Dashboard is taken from the official one provided by Tanzu/Velero:
<https://grafana.com/grafana/dashboards/16829-kubernetes-tanzu-velero/>

There's an issue with the datasource of each widget when the dashboard is imported as-is from upstream.

You need to change all the occurences of `"uid": "${DS_PROMETHEUS-1}"` with `"uid": "${datasource}"`, and while we are at it we polish a little the Title:

```bash
# command for MacOS version of sed
sed -i -e 's/"uid": "${DS_PROMETHEUS-1}"/"uid": "${datasource}"/g' velero.json
# using `#` as separator instead of `/` for simplicity
sed -i -e 's#Tanzu/Velero#Velero#g' velero.json
```
