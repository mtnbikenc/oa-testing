FROM registry.fedoraproject.org/fedora:29

EXPOSE 22 4403 8080 8000 9876 22

COPY packages /

ENV USER_NAME=user \
    USER_ID=1000
ENV HOME=/home/${USER_NAME}
RUN dnf -y update && \
    dnf -y install $(<packages) && \
    dnf clean all

RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -u ${USER_ID} -G users,wheel,root -d ${HOME} --shell /bin/bash -m ${USER_NAME} && \
    usermod -p "*" ${USER_NAME} && \
    sed -i 's/requiretty/!requiretty/g' /etc/sudoers && \
    sed -ri 's/StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config

USER ${USER_NAME} 
WORKDIR /projects

RUN sudo chgrp -R 0 ${HOME} /projects /etc/passwd /etc/group && \ 
    sudo chmod -R g+rwX ${HOME} /projects /etc/passwd /etc/group

RUN timeout 30 sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true

COPY ["entrypoint.sh","/home/user/entrypoint.sh"]
RUN sudo mkdir /var/run/sshd && \
    sudo  ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    sudo  ssh-keygen -t rsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    sudo  ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key -N '' && \
    sudo chgrp -R 0 ~ && \
    sudo chmod -R g+rwX ~

COPY . ${HOME}/oa-testing

ENTRYPOINT ["/home/user/entrypoint.sh"]
CMD tail -f /dev/null
