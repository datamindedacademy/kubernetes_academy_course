# Deployments

## Steps

- create deployment for nilli9990/cat-webapp (port 5000)
  - generate template using: `kubectl create deployment cat-webapp --image=nilli9990/cat-webapp --port 5000 --dry-run=client -o yaml > cat-webapp-deployment.yaml`
- (gitpod) Setup port forwarding to the pod
  - `kubectl port-forward <pod> 5555:5000` where local port 5555 and container port is 5000.
  - Browse to the url by clicking on the ports tab and click on the browser icon next to port 8080.
- (microk8s) go to the webpage 
- update deployment with env variable CAT_INDEX=[1..3]
- watch rollout status
- check webpage
