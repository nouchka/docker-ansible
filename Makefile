DOCKER_IMAGE=ansible
DOCKER_NAMESPACE=nouchka
NAME=$(DOCKER_NAMESPACE)-$(DOCKER_IMAGE)
VERSION=0.1
DESCRIPTION=$(DOCKER_IMAGE) with docker in a package
URL=https://github.com/nouchka/docker-$(DOCKER_IMAGE)
VENDOR=katagena
MAINTAINER=Jean-Avit Promis <docker@katagena.com>
LICENSE=Apache License 2.0

prefix = /usr/local

.DEFAULT_GOAL := build

deb:
	mkdir -p build/
	mkdir -p build/usr/sbin/
	cp -Rf bin/* build/usr/sbin/
	cp bin/ansible build/usr/sbin/ansible-playbook
	cp bin/ansible build/usr/sbin/ansible-galaxy
	cp bin/ansible-vault build/usr/sbin/ansible-lint

build-deb: deb
	rm -f $(NAME)_$(VERSION).$(TRAVIS_BUILD_NUMBER)_amd64.deb
	fpm -t deb -s dir -n $(NAME) -v $(VERSION).$(TRAVIS_BUILD_NUMBER) --description "$(DESCRIPTION)" -C build \
	--vendor "$(VENDOR)" -m "$(MAINTAINER)" --license "$(LICENSE)" --url $(URL) --deb-no-default-config-files \
	-d docker-ce \
	.
	rm -rf build/

push-deb: build-deb
	package_cloud push nouchka/home/ubuntu/xenial $(NAME)_*.deb

symbolinks_test:
	cd bin/ && ln -s ansible ansible-playbook && ln -s ansible ansible-galaxy
	cd test/ && ls -al
	cd test/ && ../bin/ansible-galaxy --version
	cd test/ && ../bin/ansible-playbook --check test.yml
	cd bin/ && rm -rf ansible-playbook && rm -rf ansible-galaxy

build-version:
	@chmod +x ./hooks/build
	DOCKER_TAG=$(VERSION) IMAGE_NAME=$(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) ./hooks/build

.PHONY: build
build:
	$(MAKE) -s build-version VERSION=latest
	$(MAKE) -s build-version VERSION=2.4
	$(MAKE) -s build-version VERSION=2.5
	$(MAKE) -s build-version VERSION=2.6

.PHONY: test
test:
	docker-compose -f docker-compose.test.yml up

install:
	install bin/ansible $(prefix)/bin/ansible
	ln -sfn $(prefix)/bin/ansible $(prefix)/bin/ansible-playbook
	ln -sfn $(prefix)/bin/ansible $(prefix)/bin/ansible-galaxy
	install bin/ansible-vault $(prefix)/bin/ansible-vault
	ln -sfn $(prefix)/bin/ansible-vault $(prefix)/bin/ansible-lint
