.PHONY: fmt
fmt: packerfmt

.PHONY: packerfmt
packerfmt:
	packer fmt -recursive .

.PHONY: lint
lint: packerlint yamllint ansiblelint flake8

.PHONY: packerlint
packerlint:
	packer fmt -check -recursive .

.PHONY: yamllint
yamllint:
	yamllint .

.PHONY: ansiblelint
ansiblelint:
	ansible-lint -p *

.PHONY: flake8
flake8:
	flake8 .

.PHONY: clean
clean:
	find . -type d -name __pycache__ | xargs rm -rf {}
