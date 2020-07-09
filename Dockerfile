ARG  BASE_IMAGE=stretch
FROM debian:${BASE_IMAGE}
LABEL maintainer="Jean-Avit Promis docker@katagena.com"
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-ansible"

ARG DOCKER_TAG=latest
ARG ANSIBLEVERSION=2.9
## MINOR_TAGS=2.9.10-1ppa~bionic 2.9.10-1ppa~bionic 2.8.12-1ppa~bionic 2.7.18-1ppa~bionic 
## LATEST_RELEASE=v2.9.6
LABEL version="${DOCKER_TAG}"

ENV DEBIAN_FRONTEND=noninteractive

ARG APT_KEY=0x93C4A3FD7BB9C367

RUN export uid=1000 gid=1000 && \
	mkdir -p /home/developer && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/developer && \
	apt-get update --fix-missing && \
	apt-get install -y -q --no-install-recommends gnupg=* dirmngr=* curl=* && \
	echo "deb http://ppa.launchpad.net/ansible/ansible-${ANSIBLEVERSION}/ubuntu bionic main" >> /etc/apt/sources.list && \
##	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "${APT_KEY}" && \
	curl -sL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x93C4A3FD7BB9C367" | apt-key add && \
	apt-get update --fix-missing && \
	apt-get install -y -q --no-install-recommends ansible=* python=* rsync=* vim=* openssh-client=* python-pip=* && \
	pip install wheel>=0.18 && \
	pip install dopy>=0.3.5 && \
	pip install google-auth>=1.3.0 && \
	pip install boto>=2 && \
	pip install boto3>=3 && \
	pip install ansible-lint>=1 && \
	pip install ara>=1 && \
	pip install github3.py>=1 && \
	pip install netaddr>=0.7 && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/developer/config/
USER developer

CMD [ "ansible-playbook", "--version" ]
