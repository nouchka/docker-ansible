DOCKER_IMAGE=ansible
## https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html
VERSIONS=2.9 2.8 2.7

include Makefile.docker

PACKAGE_VERSION=0.1
DEBVERSIONS=2.9 2.8 2.7

include Makefile.package

check-version:
	docker run --rm $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) dpkg-query --showformat='$${Version} ' --show $(DOCKER_IMAGE)

deb:
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

install:
	install bin/ansible $(prefix)/bin/ansible
	ln -sfn $(prefix)/bin/ansible $(prefix)/bin/ansible-playbook
	ln -sfn $(prefix)/bin/ansible $(prefix)/bin/ansible-galaxy
	install bin/ansible-vault $(prefix)/bin/ansible-vault
	ln -sfn $(prefix)/bin/ansible-vault $(prefix)/bin/ansible-lint
