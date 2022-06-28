# Dockershim 사용 중단

## 개요

EKS Kubernetes v1.23 버전부터 dockershim이 사용중단(deprecated) 될 예정이다.  
EKS 버전 업그레이드 시 컨테이너 런타임이 dockershim에서 containerd로 변경되는 부분을 미리 대비할 필요가 있다.

&nbsp;

## 참고자료

[AWS 공식문서 | Dockershim 사용 중단](https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/dockershim-deprecation.html)
[Kubernetes 공식문서 | Migrating from dockershim](https://kubernetes.io/docs/tasks/administer-cluster/migrating-from-dockershim/_print/)
