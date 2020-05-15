FROM centos:7

RUN yum install gedit openssh-server xauth -y

RUN echo -e "[winswitch]\nname=Winswitch $releasever - $basearch\nenabled=1\nmetadata_expire=1d\ngpgcheck=1\ngpgkey=https://xpra.org/gpg.asc\nbaseurl=https://xpra.org/dists/CentOS/\$releasever/\$basearch/" >> /etc/yum.repos.d/xpra.repo

RUN yum install xpra python-websockify -y 

RUN sshd-keygen; /usr/sbin/sshd -f /etc/ssh/sshd_config; echo "/usr/sbin/sshd -f /etc/ssh/sshd_config" >> /root/.bashrc

RUN sed -i 's/X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config; sed -i 's/X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config; /usr/sbin/sshd

RUN dbus-uuidgen > /etc/machine-id 

RUN xpra start --bind-tcp=0.0.0.0:3333 --html=on --start-child=gedit --systemd-run=no; echo "xpra start --bind-tcp=0.0.0.0:3333 --html=on --start-child=gedit --systemd-run=no" >> /root/.bashrc
