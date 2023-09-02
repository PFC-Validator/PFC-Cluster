#!/usr/bin/env bash

sudo mkdir -p /etc/ansible/
for i in  {1..3}
do
	docker kill test-${i} >/dev/null 2>&1
	docker rm -f -v test-${i}  >/dev/null 2>&1
done 
cat > hosts << EOF
[myvirtualmachines]
EOF
chmod 644 hosts
cat > inventory.yaml <<EOF
virtualmachines:
  vars:
      ansible_user: ubuntu
      deployment_user: user
      ansible_ssh_user: root
  hosts:
EOF

for i in  {1..3}
do
	docker run -d --name test-${i} sshd_ubu
	ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' test-${i})
	echo $ip  >> hosts
cat >>inventory.yaml <<EOF
    vm0${i}:
      ansible_host: $ip
EOF

done
sudo cp hosts /etc/ansible
#
#ansible all -m ping -u ubuntu
ansible virtualmachines -m ping  -i inventory.yaml