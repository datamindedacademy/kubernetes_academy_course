# Ingress

## Steps

Setup ingress for 2 deployments of our cats deployment with different images.

## Eks cluster

In order to get ingress running, you first need a cluster-ip service for your deployments.
Now you can create the ingress resource, using the `ingress-template.yaml` and filling in the <TODO> fields
- define the dns records corresponding to the 2 cat services
- create 2 rules that forward requests to the respective services using a convention like `<first-username>-cat-<index>.k8sacademy.waydata.be`

Note: 
- if your target-type is instance, your services must be a NodePort as it then uses the nodeport to go to your services
- ingressClassName: "alb"

## Local setup (microk8s)
- cat0.example.com cat0-svc
- cat1.example.com cat1-svc

Make sure your local kubernetes cluster has ingress enabled
Make sure to change the /etc/hosts with the correct entries such that they are routable