prefix = /usr/local

install:
	install bin/ansible $(prefix)/bin/ansible
	ln -s $(prefix)/bin/ansible $(prefix)/bin/ansible-playbook
	ln -s $(prefix)/bin/ansible $(prefix)/bin/ansible-galaxy

symbolinks_test:
	cd bin/ && ln -s ansible ansible-playbook && ln -s ansible ansible-galaxy
	cd test/ && ls -al
	cd test/ && ../bin/ansible-galaxy --version
	cd test/ && ../bin/ansible-playbook --check test.yml
	cd bin/ && rm -rf ansible-playbook && rm -rf ansible-galaxy
