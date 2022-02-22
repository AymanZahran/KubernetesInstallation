#/bin/bash
MasterIP=13.52.179.236
Node1IP=54.193.64.106
Node2IP=54.241.106.235
UserName=cloud_user
Password=P@ssw0rdP@ssw0rd
MasterInsallation="KubeInstallationMaster.sh"
NodeInstallation="KubeInstallationNodes.sh"


scp ./$MasterInsallation $UserName@$MasterIP:~/$MasterInsallation
echo "spawn ssh-copy-id -o StrictHostKeyChecking=no -i $UserName@$MasterIP"  > tmp.sh
echo "expect \"*assword:*\"" >> tmp.sh
echo "send \"$Password\r\""  >> tmp.sh
echo "expect eof" >> tmp.sh
echo "exit" >> tmp.sh
chmod +x tmp.sh
expect -f tmp.sh
ssh cloud_user@13.52.179.236 "chmod +x $MasterInsallation"
ssh cloud_user@13.52.179.236 "bash -x $MasterInsallation"

scp ./$NodeInstallation $UserName@$Node1IP:~/$NodeInstallation
echo "spawn ssh-copy-id -o StrictHostKeyChecking=no -i $UserName@$Node1IP"  > tmp.sh
echo "expect \"*assword:*\"" >> tmp.sh
echo "send \"$Password\r\""  >> tmp.sh
echo "expect eof" >> tmp.sh
echo "exit" >> tmp.sh
chmod +x tmp.sh
expect -f tmp.sh
ssh cloud_user@13.52.179.236 "chmod +x $NodeInstallation"
ssh cloud_user@13.52.179.236 "bash -x $NodeInstallation"

scp ./$NodeInstallation $UserName@$Node2IP:~/$NodeInstallation
echo "spawn ssh-copy-id -o StrictHostKeyChecking=no -i $UserName@$Node2IP"  > tmp.sh
echo "expect \"*assword:*\"" >> tmp.sh
echo "send \"$Password\r\""  >> tmp.sh
echo "expect eof" >> tmp.sh
echo "exit" >> tmp.sh
chmod +x tmp.sh
expect -f tmp.sh
ssh cloud_user@13.52.179.236 "chmod +x $NodeInstallation"
ssh cloud_user@13.52.179.236 "bash -x $NodeInstallation"

rm -rf tmp.sh
rm -f $MasterInsallation
rm -f $NodeInstallation

