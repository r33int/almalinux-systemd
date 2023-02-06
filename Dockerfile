ARG VERSION=8

FROM almalinux:${VERSION}
LABEL maintainer="HIFIS (https://www.hifis.net)"
ENV container=podman

ENV USER=molecule

# Install systemd -- See https://hub.docker.com/_/centos/
RUN rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install requirements.
RUN dnf -y install rpm dnf-plugins-core \
 && dnf -y update \
 && dnf -y install \
      epel-release \
      initscripts \
      sudo \
      which \
      hostname \
      libyaml \
      python3 \
 && dnf clean all

# Create nonroot user and enable passwordless sudo.
RUN useradd -m -g sudo -s /bin/bash $USER
RUN echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

CMD ["/usr/lib/systemd/systemd"]
