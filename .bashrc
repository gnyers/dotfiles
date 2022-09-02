#!/bin/bash



### k8s settings
which kubectl \
	&& {
	kubectl completion bash > ~/.bashrc.kubectl;
	source ~/.bashrc.kubectl;
	complete -F __start_kubectl k;

	alias \
		k='kubectl' \
		kg='kubectl get' \
		kd='kubectl delete' \
		ka='kubectl apply' \
		ke='kubectl explain' \
		ks='kubectl describe' \
		kgp='kubectl get pod' \
		kgd='kubectl get deploy' \
		;
	
	export \
		oy='-o yaml' \
		ow='-o wide' \
		dry='--dry-run=client' \
		now='--force --grace-period=0' \
		;
	}

### create .vimrc
cat <<EOF > ~/.vimrc
set tabwidth=2 softtabwidth=2 shiftwidth=2 expandtab 
set textwidth=80 paste cursorcolumn
syntax on
EOF
