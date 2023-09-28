EKS_CLUSTER_NAME = alb-controller-test
IAM_POLICY_NAME = AWSLoadBalancerControllerIAMPolicy
IAM_ROLE_NAME = AmazonEKSLoadBalancerControllerRole
IRSA_NAME = aws-load-balancer-controller
NAMESPACE = kube-system

install: create-iam-role create-irsa release-helm-charts
uninstall:
	@helm uninstall -n ${NAMESPACE} aws-load-balancer-controller
	@eksctl delete iamserviceaccount \
		--cluster ${EKS_CLUSTER_NAME} \
		--namespace=${NAMESPACE} \
		--name=${IRSA_NAME}
	@POLICY_ARN=$$(aws iam list-policies --query 'Policies[?PolicyName==`${IAM_POLICY_NAME}`].Arn' --output text) && \
		echo "[info] IAM Policy arn: $${POLICY_ARN}" && \
		aws iam delete-policy --policy-arn $${POLICY_ARN}

create-iam-role:
	@-aws iam create-policy --policy-name ${IAM_POLICY_NAME} --policy-document file://policy.json > /dev/null 2>&1 || echo "[info] IAM Role ${IAM_ROLE_NAME} already exist. skip creating IAM Role"
	@eksctl utils associate-iam-oidc-provider --cluster ${EKS_CLUSTER_NAME} --approve

create-irsa:
	@echo "[info] create a IRSA for ALB controller"
	@POLICY_ARN=$$(aws iam list-policies --query 'Policies[?PolicyName==`${IAM_POLICY_NAME}`].Arn' --output text) && \
		echo "[info] IAM Policy arn: $${POLICY_ARN}" && \
		eksctl create iamserviceaccount \
			--cluster ${EKS_CLUSTER_NAME} \
			--namespace=${NAMESPACE} \
			--name=${IRSA_NAME} \
			--role-name ${IAM_ROLE_NAME} \
			--attach-policy-arn=$${POLICY_ARN} \
			--override-existing-serviceaccounts \
			--approve

release-helm-charts:
	@echo "[info] install latest ALB controller using helm charts"
	@helm repo add eks https://aws.github.io/eks-charts
	@helm repo update
	@helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
		-n ${NAMESPACE} \
		--set clusterName=${EKS_CLUSTER_NAME} \
		--set serviceAccount.create=false \
		--set serviceAccount.name=${IRSA_NAME}

