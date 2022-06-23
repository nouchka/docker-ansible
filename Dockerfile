ARG  BASE_IMAGE=bullseye-slim
FROM debian:${BASE_IMAGE}

ARG VERSION=4
## MINOR_TAGS=2.11.12 2.11.12 2.13.1 
## LATEST_RELEASE=2.11.12 
LABEL version="${DOCKER_TAG}"

ENV DEBIAN_FRONTEND=noninteractive

ARG APT_KEY=0x93C4A3FD7BB9C367

RUN export uid=1000 gid=1000 && \
	mkdir -p /home/developer && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/developer && \
	apt-get update --fix-missing && \
	apt-get install -y -q --no-install-recommends python3=* rustc=* rsync=* vim=* openssh-client=* python3-pip=* python3-setuptools=* && \
##	pip3 install wheel>=0.18 && \
	pip3 install ansible==${VERSION}.* && \
	pip3 install google-auth>=1.3.0 && \
	pip3 install boto>=2 && \
	pip3 install boto3>=3 && \
	pip3 install ansible-lint>=1 && \
	pip3 install github3.py>=1 && \
	pip3 install ansible-modules-hashivault>=1 && \
	pip3 install hvac && \
	pip3 install ara>=1 && \
	pip3 install PyMySQL>=1 && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/developer/config/
USER developer

CMD [ "ansible-playbook", "--version" ]
