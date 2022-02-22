##### On all Nodes #####
# Make the initial configuration for Docker before installing it.
sudo mkdir /etc/docker

# Create the daemon.json config file that Docker will use.
cat <<EOF | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF

# Update your packages, and install dependencies.
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release

# Update repositories and gpg keys for Docker.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update your repositories.
sudo apt-get update

# Add the packages and gpg key for Kubernetes.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update your repositories one last time.
sudo apt-get update

# Now, you can install Docker and Kubernetes packages.
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu kubelet=1.14.5-00 kubeadm=1.14.5-00 kubectl=1.14.5-00 --allow-unauthenticated
sudo apt-mark hold docker-ce kubelet kubeadm kubectl

# Enable iptables bridge call.
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo modprobe br_netfilter
sudo sysctl -p

##### On the Kube Master Server #####
# Initialize the cluster.
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up local kubeconfig.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Flannel networking.
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
# # Note: If you are using Kubernetes 1.16 or later, you will need to use a newer Flannel installation yaml instead:
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/3f7d3e6c24f641e7ff557ebcea1136fdf4b1b6a1/Documentation/kube-flannel.yml

##### On the Kube Node Server #####
# Join the node to the cluster.
sudo kubeadm join $controller_private_ip:6443 --token $token --discovery-token-ca-cert-hash $hash

# Finally, verify all nodes are joined and ready:
kubectl get nodes

