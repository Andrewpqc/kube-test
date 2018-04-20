#!/bin/bash


#查看gcr.io镜像
#https://console.cloud.google.com/kubernetes/images/list?location=GLOBAL&project=google-containers
#通过下面的网址查看依赖镜像的版本号：
#https://kubernetes.io/docs/admin/kubeadm/
set -o errexit
set -o nounset
set -o pipefail

KUBE_VERSION=v1.7.2
KUBE_PAUSE_VERSION=3.0
ETCD_VERSION=3.0.17
DNS_VERSION=1.14.



echo '============================================================'
echo '====================Add docker yum repo...=================='
echo '============================================================'
#docker yum源
cat >> /etc/yum.repos.d/docker.repo <<EOF
[docker-repo]
name=Docker Repository
baseurl=http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7
enabled=1
gpgcheck=0
EOF
echo "Add docker yum repo success!"

echo '============================================================'
echo '====================Install docker...======================='
echo '============================================================'
#查看docker版本
#yum list docker-engine showduplicates
#安装docker
yum install -y docker-engine-1.12.6-1.el7.centos.x86_64

echo "Install docker success!"


GCR_URL=gcr.io/google_containers
ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/szss_k8s

images=(kube-proxy-amd64:${KUBE_VERSION}
kube-scheduler-amd64:${KUBE_VERSION}
kube-controller-manager-amd64:${KUBE_VERSION}
kube-apiserver-amd64:${KUBE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
etcd-amd64:${ETCD_VERSION}
k8s-dns-sidecar-amd64:${DNS_VERSION}
k8s-dns-kube-dns-amd64:${DNS_VERSION}
k8s-dns-dnsmasq-nanny-amd64:${DNS_VERSION})


for imageName in ${images[@]} ; do
  docker pull $GCR_URL/$imageName
  docker tag $GCR_URL/$imageName $ALIYUN_URL/$imageName
  docker push $ALIYUN_URL/$imageName
  docker rmi $ALIYUN_URL/$imageName
done