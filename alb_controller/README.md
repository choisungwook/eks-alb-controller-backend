# 개요
* ALB controller 설치 가이드
* IRSA사용

# 설치
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

3. IRSA 생성

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
