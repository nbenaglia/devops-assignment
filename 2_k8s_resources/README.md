# Kubernetes Resources

Steps:

1. Launch minikube (must be locally installed)

2. Apply these manifests locally:
  `kubectl apply -f .`

3. Open a port-forward connection:
  `kubectl port-forward svc/myapp 8080:8080`

4. Connect to `http://127.0.0.1:8080`

5. Enjoy the app
