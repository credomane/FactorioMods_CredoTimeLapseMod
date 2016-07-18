BUILD_DIR := build

# Locate JQ for parsing info.json
JQ = $(shell which jq 2> /dev/null)

ifeq ($(strip $(JQ)),)
$(error "jq program is required to parse info.json")
else
MODNAME = $(shell cat info.json | $(JQ) -r .name)
MODVERSION = $(shell cat info.json | $(JQ) -r .version)
endif

all: release

release:
	@mkdir -p "./$(BUILD_DIR)"
	git archive --prefix "$(MODNAME)_$(MODVERSION)/" -o "./$(BUILD_DIR)/$(MODNAME)_$(MODVERSION).zip" HEAD

dev: clean-dev
	@mkdir -p $(BUILD_DIR)
	git archive --prefix "$(MODNAME)_$(MODVERSION)/" -o "./$(BUILD_DIR)/temp.tar" HEAD
	tar -xvf "./$(BUILD_DIR)/temp.tar" -C "$(BUILD_DIR)"
	@rm "./$(BUILD_DIR)/temp.tar"
	set -e; for file in $$(find . -iname '*.lua' -type f -not -path "/$(BUILD_DIR)/*"); do echo "Checking syntax: $$file" ; luac -p $$file; done;

cleanall: clean clean-dev

clean:
	rm -rf "./$(BUILD_DIR)/*.zip"

clean-dev:
	rm -rf "./$(BUILD_DIR)/$(MODNAME)_$(MODVERSION)/"
