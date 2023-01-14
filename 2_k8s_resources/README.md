# Kubernetes Resources

Steps:

1) Launch minikube (must be locally installed)

1) Apply these manifests locally:
  `kubectl apply -f .`

2) Open a port-forward connection:
  `kubectl port-forward svc/myapp 8080:8080`

3) Connect to `http://127.0.0.1:8080`

4) Enjoy the app
