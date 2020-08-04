#!/usr/bin/env bash
echo "--------change hosts--------"
set ff=unix
cat >/etc/hosts <<EOF
192.168.5.128 server01
192.168.5.129 server02
192.168.5.130 server03
EOF

#centos8 用命令
nmcli c reload
#centos8 以下 用命令
systemctl restart network
cat >/etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

## Install prerequisites.
yum install -y yum-utils device-mapper-persistent-data lvm2

## Add docker repository.
sudo yum-config-manager -y --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum install runc
yum erase runc -y
#rpm -ivh containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/edge/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm

## Install docker.
yum makecache fast && yum -y install docker-ce-3:docker-ce-18.09.9

## Create /etc/docker directory.
mkdir /etc/docker

# Setup daemon.
#"insecure-registries": [masterIP,"docker.work.net"]
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "hosts":[
    "unix:///var/run/docker.sock",
    "tcp://0.0.0.0:2375"
  ],
  "graph": "/data/docker",
  "registry-mirrors": ["https://sqygw205.mirror.aliyuncs.com","http://docker.work.net"],
  "insecure-registries": ["192.168.229.129","docker.work.net"]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl enable docker
systemctl restart docker
systemctl status docker

systemctl disable firewalld
systemctl stop firewalld

swapoff -a
# Set SELinux in permissive mode (effectively disabling it)
# 将 SELinux 设置为 permissive 模式(将其禁用)
setenforce 0
sed -i 's/^SELINUX=.*$/SELINUX=permissive/' /etc/selinux/config


yum install -y kubelet-1.16.4 kubeadm-1.16.4 kubectl-1.16.4 --disableexcludes=kubernetes

systemctl enable kubelet
systemctl start kubelet

cat > /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
echo "1" > /proc/sys/net/ipv4/ip_forward

# 下载k8s.1.16.4所需要的镜像列表
#echo 'docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.16.4
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.16.4 k8s.gcr.io/kube-proxy:v1.16.4' > ~/down-images-join.sh
#
#chmod +777 ~/down-images-join.sh
#sh ~/down-images-join.sh

chmod +777 ~/down-images.sh
sh ~/down-images.sh
# 执行节点加入操作
# 示例： kubeadm join 192.168.229.129:6443 --token jrk73b.m6ly1m4pz5g7ymbm --discovery-token-ca-cert-hash sha256:18c361e1e5031ab1fb0c195b3dff6b2f3557c98db621cf34077afe66845e40ab
# 下面的join_token要替换与具体的主节点的token , 主节点执行命令：kubeadm token list 查看可用的token列表，主节点创建新token命令：kubeadm token create
# 必须加上--ignore-preflight-errors=all 否则会有异常 [ERROR DirAvailable--etc-kubernetes-manifests]: /etc/kubernetes/manifests is not empty
#查看sha256命令  openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
kubeadm join 192.168.229.129:6443 --token xfaa1n.fjr6w8aeadtibfum --discovery-token-ca-cert-hash sha256:fdb1ce52723316b7dac9c0b42917790f8cbcdb89c57d1435d01c1c01014a0e4a --ignore-preflight-errors=all


kubectl get nodes
