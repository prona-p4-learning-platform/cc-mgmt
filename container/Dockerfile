FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  openssh-server \
  curl \
  && mkdir /var/run/sshd \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
  && rm kubectl

RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

COPY create_user_cert.sh /root/create_user_cert.sh
RUN chmod +x /root/create_user_cert.sh

COPY setup_k8s.sh /root/setup_k8s.sh
RUN chmod +x /root/setup_k8s.sh

COPY undeploy_k8s.sh /root/undeploy_k8s.sh
RUN chmod +x /root/undeploy_k8s.sh

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

COPY role-template.yaml /root/role-template.yaml

EXPOSE 22

ENTRYPOINT ["/root/entrypoint.sh"]