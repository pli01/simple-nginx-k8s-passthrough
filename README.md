# simple-nginx-k8s-passthrough
simple reverse proxy nginx configuration to allow ssl passthrough to k8s api and expose /portainer

The use Case:
For small lab k8s testing, want to expose :
 * on dedicated url : only k8s administration, and portainer
 * and on another url, expose users workload

Use one Cloud Floating IP associated with this nginx container and expose the cluster k8s api (with it s own cert) and /portainer app
Use another Cloud Floating IP to expose other k8s routes (users)

```
[ FIP ] -> [ https nginx ] -> [ stream tcp with ssl passthrough ] -> [ https k8s api with ssl cert ]
[ FIP ] -> [ http nginx ] -> [ 80 tcp ] -> [ portainer on k8s ]
```

# Usage:
* define following variables:
```
export K8S_HOST=k8s_privateip
export K8S_PORT=6443
export PORTAINER_HOST=k8s_privateip
export PORTAINER_PORT=80
```

* Start nginx:
```
 make up
```
* Test K8S api
```
curl https://FIP/
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "Unauthorized",
  "reason": "Unauthorized",
  "code": 401
```
* Test portainer
curl -L http://FIP/
```
```

* Down
```
make down
```
