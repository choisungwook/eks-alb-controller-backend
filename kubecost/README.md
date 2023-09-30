# 개요
* EKS 실시간 비용 측정

# 사용 방법
* 설치

```bash
make install

# pod 확인
kubectl get pods -n kubecost
```

* kubecost 대시보드 접속
  * 설치 후 약 15분 부팅시간 필요
```bash
kubectl port-forward --namespace kubecost deployment/kubecost-cost-analyzer 9090
http://localhost:9090
```

* 삭제

```bash
make uninstall
```

# 참고자료
* aws 문서: https://docs.aws.amazon.com/eks/latest/userguide/cost-monitoring.html
* helm chart github: https://github.com/kubecost/cost-analyzer-helm-chart
