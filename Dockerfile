ARG  BASE_IMAGE=bookworm-slim
FROM debian:${BASE_IMAGE}

ARG VERSION=11
## MINOR_TAGS=2.18.5 2.18.5 
## LATEST_RELEASE=2.18.5 
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
	apt-get install -y -q --no-install-recommends python3=* rustc=* rsync=* git=* curl=* vim=* openssh-client=* python3-pip=* python3-setuptools=* python-is-python3=* && \
	pip3 install --no-cache-dir --break-system-packages ansible==${VERSION}.* && \
	pip3 install --no-cache-dir --break-system-packages google-auth>=1.3.0 && \
	pip3 install --no-cache-dir --break-system-packages boto>=2 && \
	pip3 install --no-cache-dir --break-system-packages boto3>=3 && \
	pip3 install --no-cache-dir --break-system-packages ansible-lint>=1 && \
	pip3 install --no-cache-dir --break-system-packages github3.py>=1 && \
	pip3 install --no-cache-dir --break-system-packages ansible-modules-hashivault>=1 && \
	pip3 install --no-cache-dir --break-system-packages hvac>=0.11 && \
	pip3 install --no-cache-dir --break-system-packages ara>=1 && \
	pip3 install --no-cache-dir --break-system-packages python-gitlab>=3 && \
	pip3 install --no-cache-dir --break-system-packages PyMySQL>=1 && \
	pip3 install --no-cache-dir --break-system-packages cryptography>=3.0 && \
	pip3 install --no-cache-dir --break-system-packages bcrypt>=4.0 && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/developer/config/
USER developer

CMD [ "ansible-playbook", "--version" ]
