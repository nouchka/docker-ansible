ARG  BASE_IMAGE=jessie
FROM debian:${BASE_IMAGE}
LABEL maintainer="Jean-Avit Promis docker@katagena.com"
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-ansible"

ARG DOCKER_TAG=latest
ARG ANSIBLEVERSION=2.6
LABEL version="${DOCKER_TAG}"

ENV DEBIAN_FRONTEND=noninteractive

ARG APT_KEY=93C4A3FD7BB9C367

RUN export uid=1000 gid=1000 && \
	mkdir -p /home/developer && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/developer && \
	echo "deb http://ppa.launchpad.net/ansible/ansible-${ANSIBLEVERSION}/ubuntu trusty main" >> /etc/apt/sources.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "${APT_KEY}" && \
	apt-get update --fix-missing && \
	apt-get install -y -q ansible python-pip rsync vim && \
	pip install 'dopy>=0.3.5,<=0.3.5' && \
	pip install docker-py && \
	pip install google-auth && \
	pip install boto && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/developer/config/
USER developer

CMD [ "ansible-playbook", "--version" ]
