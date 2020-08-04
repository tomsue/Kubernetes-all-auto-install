#!/usr/bin/env bash
# 安装k8s-dashboard扩展
kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f kubernetes-dashboard-admin.rbac.yaml
#Dashboard UI  访问地址：http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl apply -f kubernetes-dashboard-2.0.0-rc6-recommended.yaml

# 完成后等待pod:dashboard创建启动
# 查看pod状态
kubectl get pods -n kube-system
# 查看service状态
kubectl get service -n kube-system
#查看密钥
kubectl get secret -n kubernetes-dashboard
#浏览器访问
kubectl proxy
#设置API server接收所有主机的请求
#kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$'
#通过其它主机访问就需要指定监听的地址
#kubectl proxy --address=0.0.0.0
#打开浏览器：访问 ：https://localhost:30001，使用token登录，token查看方法如下
#kubectl -n kube-system get secret
#kubectl -n kube-system describe secret kubernetes-dashboard-admin-token-skhfh #{上条命令输出的结果中复制的类似kubernetes-dashboard-admin-token-skhfh的key字符串到这里替换}
#复制tokdn数据到登录框内登录即可登录