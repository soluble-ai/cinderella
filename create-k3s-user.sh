#!/bin/bash

cluster=k3s-default

mkdir tls

export PATH=/usr/local/bin:$PATH

cp /var/lib/rancher/k3s/server/tls/client-ca.crt tls
cp /var/lib/rancher/k3s/server/tls/client-ca.key tls

echo "generate user cert"
openssl genrsa -out tls/user.key 2048
openssl req -key tls/user.key -new -out tls/user.csr -subj /CN=k3s-user -nodes
openssl x509 -req -in tls/user.csr \
  -CA tls/client-ca.crt  \
  -CAkey tls/client-ca.key \
  -days 1000 -CAcreateserial -out tls/user.crt

echo "creating k3s user namespace"
kubectl create ns --save-config user
kubectl create rolebinding --save-config user-admin --namespace user --clusterrole admin \
    --user k3s-user
kubectl create clusterrolebinding --save-config user-view --user k3s-user --clusterrole view

echo "creating user kubeconfig"
cp /etc/rancher/k3s/k3s.yaml k3s-user.yaml
export KUBECONFIG=k3s-user.yaml
kubectl config set-credentials k3s-user --embed-certs=true --client-certificate=tls/user.crt \
  --client-key=tls/user.key
kubectl config set-context user --cluster default --user k3s-user --namespace user
kubectl config rename-context default admin
kubectl config use-context admin
