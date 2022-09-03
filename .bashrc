#!/bin/bash

# Download latest version of this repo as ZIP
# wget  https://github.com/gnyers/dotfiles/archive/refs/heads/main.zip

### bash settings
install_bashrc(){
	THIS=$( realpath --relative-to=. $BASH_SOURCE )
	SIG='source ~/.bashrc.custom'
	cp $THIS ~/.bashrc.custom
	grep "$SIG" ~/.bashrc \
	&& echo "*** INFO: Customizations for ~/.bashrc already installed" \
	|| { echo "*** INFO: to activate customizations, execute:";
	     echo "    echo '$SIG' >> ~/.bashrc";
	   }
} 
set -o vi
export PS1='\u@\h \W \$ \! '
alias .bashrc='source ~/.bashrc && echo "*** Reloaded: ~/.bashrc"'


### readline settings
inputrc_settings(){
	cat <<-EOF > ~/.inputrc
	"\C-f": clear-screen
	"\el": clear-screen
	"\C-e": re-read-init-file
	"\ee": re-read-init-file
	EOF
}
inputrc_settings

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
		kcs='kubectl config set-context --current --namespace' \
		kcg='kubectl config get-contexts' \
		;
	
	export \
		oy='-o yaml' \
		ow='-o wide' \
		dry='--dry-run=client' \
		now='--force --grace-period=0' \
		;
}
which kubectl > /dev/null 2>&1  && k8s_settings

### helm settings
helm_install(){
	URL_RELEASES=https://github.com/helm/helm/releases
	URL_DOWNLOAD=https://get.helm.sh
	HELM_VERSION='v3.9.3'
	[ $UID -eq 0 ] \
	  || { echo "*** ERROR: Must be root (current UID=$UID)"; exit 1; }
	echo "*** INFO: Installing Helm"
	[ -x /usr/local/bin/helm ] \
	  || (
	      curl -O ${URL_DOWNLOAD}/helm-${HELM_VERSION}-linux-amd64.tar.gz;
	      tar xf helm-${HELM_VERSION}-linux-amd64.tar.gz;
	      find . -iname helm -exec install -m 755 {} /usr/local/bin \;
	     )
}
helm_settings(){
	[ -f  ~/.bashrc.helm ] || kubectl completion bash > ~/.bashrc.kubectl;
	source ~/.bashrc.kubectl;
}
which helm > /dev/null 2>&1 \
&& helm_settings  \
|| { helm_install && helm_settings; } \



### create .vimrc
vim_settings(){
	cp ~/.vimrc ~/.vimrc.orig.$((RANDOM % 999))
	cat <<-EOF > ~/.vimrc
	set tabstop=2 softtabstop=2 shiftwidth=2 expandtab ignorecase
	set textwidth=80 paste cursorcolumn autoindent smartindent
	syntax on
	EOF
}
vim_settings

