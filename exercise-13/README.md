# Rbac

I created a role with binding and service account to get/list pods in default namespace.
I attached the correct service account to the kubectl pod such that it can list, get all pods in the default namespace.

## Steps

- Update the resources such that they run in your own namespace
- exec in the kubectl pod and list pods in your namespace (this should work)
- try to list pods in a different workspace (this should fail)
- Create a clusterRole and clusterRoleBinding such that the kubectl pod can list/get/delete pods in all namespaces
- Test whether these changes work by attaching the ClusterRole to the kubectl pod
