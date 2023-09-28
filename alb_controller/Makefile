EKS_CLUSTER_NAME = alb-controller-test

install:
	@-aws iam create-policy --policy-name "AWSLoadBalancerControllerIAMPolicy" --policy-document file://policy.json
	@eksctl utils associate-iam-oidc-provider --cluster ${EKS_CLUSTER_NAME} --approve