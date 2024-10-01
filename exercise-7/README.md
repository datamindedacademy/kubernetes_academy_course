# Services

## Gitpod and Eks network setup

If you are running locally, through microk8s or k3s, you can ignore this section and go straight to the exercise.
In order to troubleshoot some networking issues, it is best to have a look at the network setup when using gitpod with eks.

![](./networkSetupGitpodEks.drawio.png "network-setup")

### load-balancer service
- Start from the loadbalancer template and fill in the necessary information (all <TODO> fields)
  - Add https for your service on port 443 as http traffic is often blocked by firewalls or ruled as insecure by browsers. Use the following code block:
- Type the dns record in your browser and see whether you can see the cat homepage: `<first-username>.k8sacademy.waydata.be`
  - Note: it might take a couple of minutes (2-3min) before the dns record can be resolved. Also the loadbalancer on AWS takes some time to startup
- change cat index of deployment and do rolling upgrade
- refresh the webpage multiple times

Note:
- we added some custom annotations to make sure the loadbalancer is created correctly:
    ```
    service.beta.kubernetes.io/aws-load-balancer-type: "external"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:eu-west-1:338791806049:certificate/e2abe990-b0ed-46cf-9d43-94fff12d4fa6"
    external-dns.alpha.kubernetes.io/hostname: "<first-username>-cat-svc.k8sacademy.waydata.be"
    ```

More information on the annotations can be found on the AWS Load balancer controller: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/

## Local setup (microk8s)
- create a cluster-ip service for the previous deployment
- load the clusterIP of service
- change cat index of deployment and do rolling upgrade
- refresh clusterIP multiple times

