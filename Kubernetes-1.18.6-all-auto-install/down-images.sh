#!/usr/bin/env bash
#set ff=unix
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.18.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.18.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.18.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.18.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.2.24
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.4.3-0
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.2
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.6
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.7

docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2 k8s.gcr.io/pause:3.2
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.2 k8s.gcr.io/coredns:1.6.2
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.6 k8s.gcr.io/coredns:1.6.6
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.7 k8s.gcr.io/coredns:1.6.7
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.4.3-0 k8s.gcr.io/etcd:3.4.3-0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.18.3 k8s.gcr.io/kube-scheduler:v1.18.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.18.3 k8s.gcr.io/kube-controller-manager:v1.18.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.18.3 k8s.gcr.io/kube-apiserver:v1.18.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.18.3 k8s.gcr.io/kube-proxy:v1.18.3
