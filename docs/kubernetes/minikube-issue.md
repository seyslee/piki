
# minikube issue

## 증상

minikube v1.25.2에서 service 터널링이 동작하지 않아 웹 브라우저에서 확인할 수 없다.

```bash
$ kubectl get all -A
NAMESPACE     NAME                                   READY   STATUS    RESTARTS      AGE
default       pod/wordpress-74757b6ff-6q894          1/1     Running   0             74s
default       pod/wordpress-mysql-5447bfc5b-9wqqs    1/1     Running   0             74s
kube-system   pod/coredns-64897985d-hx2xt            1/1     Running   0             94s
kube-system   pod/etcd-minikube                      1/1     Running   0             107s
kube-system   pod/kube-apiserver-minikube            1/1     Running   0             107s
kube-system   pod/kube-controller-manager-minikube   1/1     Running   0             107s
kube-system   pod/kube-proxy-95htb                   1/1     Running   0             95s
kube-system   pod/kube-scheduler-minikube            1/1     Running   0             109s
kube-system   pod/storage-provisioner                1/1     Running   1 (94s ago)   106s

NAMESPACE     NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes        ClusterIP   10.96.0.1        <none>        443/TCP                  109s
default       service/wordpress         NodePort    10.100.149.146   <none>        80:30630/TCP             74s
default       service/wordpress-mysql   ClusterIP   10.100.225.191   <none>        3306/TCP                 74s
kube-system   service/kube-dns          ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   107s

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   107s

NAMESPACE     NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
default       deployment.apps/wordpress         1/1     1            1           74s
default       deployment.apps/wordpress-mysql   1/1     1            1           74s
kube-system   deployment.apps/coredns           1/1     1            1           107s

NAMESPACE     NAME                                        DESIRED   CURRENT   READY   AGE
default       replicaset.apps/wordpress-74757b6ff         1         1         1       74s
default       replicaset.apps/wordpress-mysql-5447bfc5b   1         1         1       74s
kube-system   replicaset.apps/coredns-64897985d           1         1         1       94s
```

```bash
$ minikube service wordpress
🏃  wordpress 서비스의 터널을 시작하는 중
🎉  Opening service default/wordpress in default browser...
❗  Because you are using a Docker driver on darwin, the terminal needs to be open to run it.
```

<br>

## 원인

minikube v1.25.2의 터널링 버그가 있음[^1]

<br>

## 해결방안

### 조치과정

brew로 설치한 minikube v1.25.2를 삭제하고 v1.25.1을 사용하면 된다.

**v1.25.2 삭제**

```bash
$ minikube delete
$ brew uninstall minikube
```

<br>

**v1.25.1 설치**

minikube v1.25.1을 다운로드 받는다.

```bash
$ curl -fsSL https://github.com/kubernetes/minikube/releases/download/v1.25.1/minikube-darwin-arm64 -o /opt/homebrew/bin/minikube
```

다운로드 받은 minikube v1.25.1를 명령어 실행경로로 옮깁니다.

```bash
$ echo $PATH
/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/xxxxx/.krew/bin:/opt/homebrew/opt/fzf/bin
```

minikube 파일에 실행권한을 부여한다.
```bash
$ chmod +x /opt/homebrew/bin/minikube
```

### 재시도

minikube 버전을 확인한다.

```bash
$ minikube version
minikube version: v1.25.1
commit: 3e64b11ed75e56e4898ea85f96b2e4af0301f43d
```

이전과 동일하게 service 명령어를 재실행한다.

```
$ minikube service wordpress
|-----------|-----------|-------------|---------------------------|
| NAMESPACE |   NAME    | TARGET PORT |            URL            |
|-----------|-----------|-------------|---------------------------|
| default   | wordpress |          80 | http://192.168.49.2:30630 |
|-----------|-----------|-------------|---------------------------|
🏃  wordpress 서비스의 터널을 시작하는 중
|-----------|-----------|-------------|------------------------|
| NAMESPACE |   NAME    | TARGET PORT |          URL           |
|-----------|-----------|-------------|------------------------|
| default   | wordpress |             | http://127.0.0.1:51640 |
|-----------|-----------|-------------|------------------------|
🎉  Opening service default/wordpress in default browser...
❗  Because you are using a Docker driver on darwin, the terminal needs to be open to run it.
```

minikube v1.25.1로 변경한 후 정상 진행되었다.

<br>

**Footnote**  
[^1]: https://github.com/kubernetes/minikube/issues/13736