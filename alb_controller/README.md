# 개요
* ALB controller 설치 가이드
* IRSA사용

# 설치
## 설치 순서
1. IRSA 생성
2. helm chart 릴리즈

## IRSA 생성
ALB controller가 사용하는 IRSA생성

1. IAM Policy 생성

```bash
aws iam create-policy \
  --policy-name "AWSLoadBalancerControllerIAMPolicy" \
  --policy-document file://policy.json
```

2. EKS ODIC provider 생성

```bash
CLUSTER_NAME="alb-controller-test"
eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} --approve
```

3. IRSA 생성(IAM Role과 serviceaccount 같이 생성)

```bash
POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AWSLoadBalancerControllerIAMPolicy`].Arn' --output text)
ROLE_NAME="AmazonEKSLoadBalancerControllerRole"
CLUSTER_NAME="alb-controller-test"

eksctl create iamserviceaccount \
  --cluster ${CLUSTER_NAME} \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name ${ROLE_NAME} \
  --attach-policy-arn=${POLICY_ARN} \
  --approve
```

## helm 차트 릴리즈
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update

CLUSTER_NAME="alb-controller-test"
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${CLUSTER_NAME} \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

## 설치 확인
```bash
kubectl -n kube-system get po --show-labels -lapp.kubernetes.io/instance=aws-load-balancer-controller
```

# 삭제 방법
```bash
# uninstall helm release
helm uninstall -n kube-system aws-load-balancer-controller

# async delete irsa
CLUSTER_NAME="alb-controller-test"
eksctl delete iamserviceaccount \
  --cluster ${CLUSTER_NAME} \
  --namespace=kube-system \
  --name=aws-load-balancer-controller

# delete IAM policy
POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AWSLoadBalancerControllerIAMPolicy`].Arn' --output text)
aws iam delete-policy --policy-arn ${POLICY_ARN}
```

# 스크립트를 이용한 자동화 설치&삭제
* 설치
```bash
make install
```

* 삭제
```bash
make uninstall
```
