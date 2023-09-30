HELM_CHART_VERSION = 1.96.0

install:
	helm upgrade -i kubecost oci://public.ecr.aws/kubecost/cost-analyzer --version ${HELM_CHART_VERSION} \
	--namespace kubecost --create-namespace \
	-f values.yaml

uninstall:
	helm uninstall kubecost --namespace kubecost
