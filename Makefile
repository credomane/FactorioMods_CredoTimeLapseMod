
JQ = $(shell which jq 2> /dev/null)

ifeq ($(strip $(JQ)),)
$(error "jq program is required to parse info.json")s
else
MODNAME = $(shell cat info.json | $(JQ) -r .name)
MODVERSION = $(shell cat info.json | $(JQ) -r .version)
endif

all: release
	@echo "Only making zip. 'make release' to build zip and perform gittag."

release:
	git archive --prefix "$(MODNAME)_$(MODVERSION)/" -o "$(MODNAME)_$(MODVERSION).zip" HEAD

tag: gittag

gittag:
	@echo git tag "v$(MODVERSION)"

clean:
	rm *.zip
