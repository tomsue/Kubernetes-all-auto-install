#!/usr/bin/env bash
set ff=unix
cat > /etc/yum.repos.d/kubernetes.repo <<EOF
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
yum-config-manager -y --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum install wget container-selinux -y
#wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
yum install runc
yum erase runc -y
#rpm -ivh containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/edge/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
# 查看可用版本
# yum list docker-ce --showduplicates | sort -r
## Install docker. docker-ce-18.09.9-3.el7.x86_64.rpm
#yum clean all && yum makecache && yum -y install docker-ce-3:docker-ce-18.09.9 docker-ce-cli-1:docker-ce-18.09.9 containerd.io # 需要指定版本可以写成docker-ce-18.03.1.ce
yum clean all && yum makecache && yum -y install docker-ce-docker-ce-18.09.9 docker-ce-cli-docker-ce-18.09.9 # 需要指定版本可以写成docker-ce-18.03.1.ce
## Create /etc/docker directory.
sudo mkdir /etc/docker

# Setup daemon.
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
  ]
}
{
  "graph": "/data/docker",
  "registry-mirrors": ["https://sqygw205.mirror.aliyuncs.com"]
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

# Set SELinux in permissive mode (effectively disabling it)
# 将 SELinux 设置为 permissive 模式(将其禁用)
setenforce 0
sed -i 's/^SELINUX=.*$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet-1.18.3 kubeadm-1.18.3 kubectl-1.18.3 --disableexcludes=kubernetes

systemctl enable kubelet
systemctl start kubelet

cat >  /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# 下载k8s.1.18.3所需要的镜像列表
#echo 'docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.18.3
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.18.3
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.18.3
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.18.3
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:3.2.24
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.15-0
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.3
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.4
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.2
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2 k8s.gcr.io/coredns:1.2.2
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.3 k8s.gcr.io/coredns:1.2.3
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.4 k8s.gcr.io/coredns:1.2.4
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.6.2 k8s.gcr.io/coredns:1.6.2
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:3.2.24 k8s.gcr.io/etcd:3.2.24
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.15-0 k8s.gcr.io/etcd:3.3.15-0
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.18.3 k8s.gcr.io/kube-scheduler:v1.18.3
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.18.3 k8s.gcr.io/kube-controller-manager:v1.18.3
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.18.3 k8s.gcr.io/kube-apiserver:v1.18.3
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.18.3 k8s.gcr.io/kube-proxy:v1.18.3' > ~/down-images.sh

chmod +777 down-images.sh
sh down-images.sh


sysctl net.bridge.bridge-nf-call-iptables=1
#临时关闭关闭swapoff
swapoff -a
#永久关闭swapoff
echo "vm.swappiness = 0">> /etc/sysctl.conf
sysctl -p
# 修改/etc/fstab永久关闭Swap
cp -p /etc/fstab /etc/fstab.bak$(date '+%Y%m%d%H%M%S')
# Redhat
sed -i "s/\/dev\/mapper\/rhel-swap/\#\/dev\/mapper\/rhel-swap/g" /etc/fstab
# CentOS
sed -i "s/\/dev\/mapper\/centos-swap/\#\/dev\/mapper\/centos-swap/g" /etc/fstab
#这边ip必须与配置文件ip一致
# kubeadm init --kubernetes-version=1.18.3 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.99.175
sudo kubeadm init --kubernetes-version=1.18.3 --pod-network-cidr=10.244.0.0/16
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#修改环境配置
export KUBECONFIG=/etc/kubernetes/admin.conf
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# 重要：必须安装一个pod网络附加扩展组件 ，我选择安装flanneld网络组件
#如果重装需要删除重新应用kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#没安装会报错： kubelet.go:2187] Container runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized
kubectl apply -f kube-flannel.yml
#kubectl apply -f https://github.com/tomsue/flannel/blob/master/Documentation/kube-flannel.yml
# 注意：备份类似以下格式的输出内容：用于节点加入使用
# kubeadm join 192.168.229.129:6443 --token qknvfe.v02ypyxnjvzjjzcs --discovery-token-ca-cert-hash sha256:18c361e1e5031ab1fb0c195b3dff6b2f3557c98db621cf34077afe66845e40ab
# 如生成的初始token无法使用，执行以下命令重新生成一个
# kubeadm token create --print-join-command
# 至此主节点k8s安装完成，你可以安装部署pod,或者其它扩展组件



