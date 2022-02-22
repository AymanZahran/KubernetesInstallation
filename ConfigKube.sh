#/bin/bash
MasterIP=13.52.179.236
Node1IP=54.193.64.106
Node2IP=54.241.106.235
UserName=cloud_user
Password=P@ssw0rdP@ssw0rd
ConfigKubeMaster="ConfigKubeMaster.sh"
ConfigKubeNodes="ConfigKubeNodes.sh"

git clone https://github.com/AymanZahran/KubernetesInstallation
mv KubernetesInstallation/* . && rm -rf KubernetesInstallation

# Trust aCloudGuru Servers
echo "spawn ssh-copy-id -o StrictHostKeyChecking=no -i $UserName@$MasterIP"  > tmp.sh
echo "expect \"*assword:*\"" >> tmp.sh
echo "send \"$Password\r\""  >> tmp.sh
echo "expect eof" >> tmp.sh
echo "exit" >> tmp.sh
echo "spawn ssh-copy-id -o StrictHostKeyChecking=no -i $UserName@$Node1IP"  > tmp.sh
echo "expect \"*assword:*\"" >> tmp.sh
echo "send \"$Password\r\""  >> tmp.sh
echo "expect eof" >> tmp.sh
echo "exit" >> tmp.sh
echo "spawn ssh-copy-id -o StrictHostKeyChecking=no -i $UserName@$Node2IP"  > tmp.sh
echo "expect \"*assword:*\"" >> tmp.sh
echo "send \"$Password\r\""  >> tmp.sh
echo "expect eof" >> tmp.sh
echo "exit" >> tmp.sh
chmod +x tmp.sh
expect -f tmp.sh

# Configure Kube Master
scp $ConfigKubeMaster $UserName@$MasterIP:~/$ConfigKubeMaster
ssh $UserName@$MasterIP "chmod +x $ConfigKubeMaster && bash -x $ConfigKubeMaster"

# Configure Kube Nodes
scp ./$ConfigKubeNodes $UserName@$Node1IP:~/$ConfigKubeNodes
ssh $UserName@$Node1IP "chmod +x $ConfigKubeNodes && bash -x $ConfigKubeNodes"
scp ./$ConfigKubeNodes $UserName@$Node2IP:~/$ConfigKubeNodes
ssh $UserName@$Node1IP "chmod +x $ConfigKubeNodes && bash -x $ConfigKubeNodes"

# Cleanup
rm -f tmp.sh
rm -rf KubernetesInstallation
