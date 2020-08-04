#!/usr/bin/env bash
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.16.4
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.16.4
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.16.4
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.16.4
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:3.2.24
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.15-0
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.4
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.2
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2 k8s.gcr.io/coredns:1.2.2
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.3 k8s.gcr.io/coredns:1.2.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.4 k8s.gcr.io/coredns:1.2.4
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.2 k8s.gcr.io/coredns:1.6.2
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.15-0 k8s.gcr.io/etcd:3.3.15-0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.16.4 k8s.gcr.io/kube-scheduler:v1.16.4
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.16.4 k8s.gcr.io/kube-controller-manager:v1.16.4
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.16.4 k8s.gcr.io/kube-apiserver:v1.16.4
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.16.4 k8s.gcr.io/kube-proxy:v1.16.4