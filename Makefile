
MODNAME=$(shell cat info.json | jq -r .name)
MODVERSION=$(shell cat info.json | jq -r .version)

all: release
	@echo "Only making zip. 'make release' to build zip and perform gittag."

release:
	git archive --prefix "$(MODNAME)_$(MODVERSION)/" -o "$(MODNAME)_$(MODVERSION).zip" HEAD

gittag:
	@echo git tag "v$(MODVERSION)"

clean:
	rm *.zip
