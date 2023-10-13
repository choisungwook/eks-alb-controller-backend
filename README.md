# 개요
* EKS ALB controller 설정 오류 테스트
* 블로그 정리: https://malwareanalysis.tistory.com/658

# 목차
* [1. EKS 설치](./eksctl/)
* [2. ALB controller 설치](./alb_controller/)
* [3. 예제](./manifests/)
* [4. (옵션) kubecost로 EKS가격 측정](./kubecost/)

# 실습 삭제 순서
* 순서를 지키며 삭제해야 잘 삭제됩니다.
1. manifests 삭제

```bash
kubectl delete -f manifests/
# ALB삭제되었는지 확인
```

2. ALB controller 삭제
* [ALB controller 메뉴얼 참고](./alb_controller/)

3. EKS 삭제
* [eksctl 메뉴얼 참고](./eksctl/)
