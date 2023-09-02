FROM ubuntu:22.04

RUN apt-get update && apt-get install -y openssh-server iproute2 tcpdump sudo 

RUN mkdir /var/run/sshd

RUN echo 'root:PASSWORD' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN mkdir /root/.ssh
ADD --chown=root:root  --chmod=700 authorized_keys /root/.ssh/authorized_keys

RUN adduser ubuntu --disabled-password --gecos ""
RUN usermod -aG sudo  ubuntu
RUN usermod -aG adm  ubuntu
RUN mkdir -m=700 /home/ubuntu/.ssh 
RUN chown ubuntu:ubuntu /home/ubuntu/.ssh 
ADD --chown=ubuntu:ubuntu --chmod=600  authorized_keys /home/ubuntu/.ssh/authorized_keys
ADD --chown=root:root sudo-ubuntu /etc/sudoers.d/sudo-ubuntu

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
