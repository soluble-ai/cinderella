# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

PS1="[\$(kubectl config current-context) \u@\h \W]$ "
alias admin="kubectl config use-context admin"
alias user="kubectl config use-context user"
export KUBECONFIG=/home/soluble/.kube/k3s-user.yaml

# get cluster id and make it default
(
    sn=$(kubectl get cm -A | grep cluster-info | awk '{print $1}' | head -1)
    clusterId=$(kubectl get cm cluster-info --namespace $sn -o yaml | grep "clusterId:" | awk '{print $2}')
    soluble config set defaultclusterid $clusterId > /dev/null 2>&1
)
