#!/bin/bash

set -e
set -x

[ -z "${PORTAINER_HOST}" -o -z "${PORTAINER_HOST}" -o \
  -z "${K8S_HOST}" -o -z "${K8S_HOST}" ] && exit 1

(
  # generate k8s lb ssl passthrough
  envsubst '$K8S_HOST $K8S_PORT' < /etc/nginx/nginx.k8s.template >> /etc/nginx/nginx.conf
  # generate portainer proxy_pass
  envsubst '$PORTAINER_HOST $PORTAINER_PORT' < /etc/nginx/conf.d/portainer.template | \
           sed "/^server {/a\
           error_log /dev/stderr warn;\
           access_log /dev/stdout main;
 " > /etc/nginx/conf.d/default.conf
)

