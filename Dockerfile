FROM debian:jessie
MAINTAINER Jean-Avit Promis "docker@katagena.com"
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-ansible"
LABEL version="latest"

ENV DEBIAN_FRONTEND=noninteractive

ARG ANSIBLE_REPOSITORY_KEY=93C4A3FD7BB9C367

RUN export uid=1000 gid=1000 && \
	mkdir -p /home/developer && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/developer

RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${ANSIBLE_REPOSITORY_KEY} && \
	apt-get update --fix-missing && \
	apt-get install -y -q ansible python-pip && \
	pip install 'dopy>=0.3.5,<=0.3.5'

RUN ansible-galaxy install atosatto.docker-swarm franklinkim.docker-compose

WORKDIR /home/developer/config/
USER developer
CMD [ "ansible-playbook", "--version" ]
