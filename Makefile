install:
	cd eksctl && eksctl create cluster -f config.yaml

uninstall:
	cd eksctl && eksctl delete cluster --name alb-controller-test
