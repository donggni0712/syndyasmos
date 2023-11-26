```
kubectl create ns monitoring
kubectl apply -f prometheus-cluster-role.yaml
kubectl apply -f prometheus-config-map.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-node-exporter.yaml
kubectl apply -f prometheus-svc.yaml

kubectl apply -k ./metrics-server/.

kubectl apply -f grafana.yaml
```

http://prometheus-service:8080
315
