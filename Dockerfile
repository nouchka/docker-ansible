ARG  BASE_IMAGE=bullseye-slim
FROM debian:${BASE_IMAGE}

ARG VERSION=6
## MINOR_TAGS=2.13.6 2.13.6 2.12.10 
## LATEST_RELEASE=2.13.6 
LABEL version="${DOCKER_TAG}"

ENV DEBIAN_FRONTEND=noninteractive

ARG APT_KEY=0x93C4A3FD7BB9C367

# hadolint ignore=DL3013
RUN export uid=1000 gid=1000 && \
	mkdir -p /home/developer && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/developer && \
	apt-get update --fix-missing && \
	apt-get install -y -q --no-install-recommends python3=* rustc=* rsync=* vim=* openssh-client=* python3-pip=* python3-setuptools=* python-is-python3=* && \
	pip3 install --no-cache-dir ansible==${VERSION}.* && \
	pip3 install --no-cache-dir google-auth>=1.3.0 && \
	pip3 install --no-cache-dir boto>=2 && \
	pip3 install --no-cache-dir boto3>=3 && \
	pip3 install --no-cache-dir ansible-lint>=1 && \
	pip3 install --no-cache-dir github3.py>=1 && \
	pip3 install --no-cache-dir ansible-modules-hashivault>=1 && \
	pip3 install --no-cache-dir hvac>=0.11 && \
	pip3 install --no-cache-dir ara>=1 && \
	pip3 install --no-cache-dir python-gitlab>=3 && \
	pip3 install --no-cache-dir PyMySQL>=1 && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/developer/config/
USER developer

CMD [ "ansible-playbook", "--version" ]
