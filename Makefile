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

VERSIONS=2.7 2.6 2.5 2.4
DEBVERSIONS=2.6

deb:
	mkdir -p build/
	mkdir -p build/usr/sbin/
	cp -Rf bin/* build/usr/sbin/
	cp bin/ansible build/usr/sbin/ansible-playbook
	cp bin/ansible build/usr/sbin/ansible-galaxy
	cp bin/ansible-vault build/usr/sbin/ansible-lint
	$(foreach version,$(DEBVERSIONS), cp bin/ansible build/usr/sbin/ansible$(version);)
	$(foreach version,$(DEBVERSIONS), cp bin/ansible build/usr/sbin/ansible-playbook$(version);)
	$(foreach version,$(DEBVERSIONS), cp bin/ansible build/usr/sbin/ansible-galaxy$(version);)
	$(foreach version,$(DEBVERSIONS), cp bin/ansible-vault build/usr/sbin/ansible-vault$(version);)
	$(foreach version,$(DEBVERSIONS), cp bin/ansible-vault build/usr/sbin/ansible-lint$(version);)

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

install:
	install bin/ansible $(prefix)/bin/ansible
	ln -sfn $(prefix)/bin/ansible $(prefix)/bin/ansible-playbook
	ln -sfn $(prefix)/bin/ansible $(prefix)/bin/ansible-galaxy
	install bin/ansible-vault $(prefix)/bin/ansible-vault
	ln -sfn $(prefix)/bin/ansible-vault $(prefix)/bin/ansible-lint

build-latest:
	$(MAKE) -s build-version VERSION=latest

build-version:
	@chmod +x ./hooks/build
	DOCKER_TAG=$(VERSION) IMAGE_NAME=$(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) ./hooks/build

.PHONY: build
build: build-latest
	$(foreach version,$(VERSIONS), $(MAKE) -s build-version VERSION=$(version);)

version:
	docker run --rm $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) dpkg-query --showformat='$${Version} ' --show $(DOCKER_IMAGE)

versions:
	$(foreach version,$(VERSIONS), $(MAKE) -s version VERSION=$(version);)

.PHONY: test
test:
	docker-compose -f docker-compose.test.yml up
