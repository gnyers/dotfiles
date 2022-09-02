#!/bin/bash

# Download this repo as ZIP
# curl -O dotfiles.zip  https://github.com/gnyers/dotfiles/archive/refs/heads/main.zip

### bash settings
set -o vi
export PS1='\u@\h \W \$ \! '

### k8s settings
k8s_settings(){
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
which kubectl && k8s_settings

### create .vimrc
vim_settings(){
	cp ~/.vimrc ~/.vimrc.orig.$((RANDOM % 999))
cat <<EOF > ~/.vimrc
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab 
set textwidth=80 paste cursorcolumn
syntax on
EOF
}
vim_settings

