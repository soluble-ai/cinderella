#!/bin/bash

cp user.bashrc.sh ~soluble/.bashrc
chown soluble ~soluble/.bashrc
mkdir -p ~soluble/.kube
cp k3s-user.yaml ~soluble/.kube
chown -R soluble ~soluble/.kube
