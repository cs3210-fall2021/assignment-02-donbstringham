.DEFAULT_GOAL=help

# Go variables
CC=go
GOBASE ?= $(shell pwd)
GOPATH ?= "$(GOBASE)/vendor:$(GOBASE)"
GOBIN ?= $(GOBASE)/bin
GOFILES ?= $(wildcard *.go)

# Application variables
ALL_PACKAGES ?= $(shell go list ./...)
APP_NAME ?= $(shell basename "$(pwd)")
BUILD_TIME ?= $(shell date +%FT%T%z)
REPO_OWNER ?= $(shell git describe --tags 2>/dev/null)
VERSION ?= $(shell git describe --tags 2>/dev/null)

# Targets
help:
	@echo
	@echo '  Usage:'
	@echo '    make <target>'
	@echo
	@echo '  Targets:'
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@echo

bld:				## Build the binaries
bld: clean go-build
	@echo " > Building binary..."


clean: 				## Clean project directories
clean: go-clean
	-rm -r ./bin
	-mkdir ./bin

info:				## Present version, owner and packages
info:
	@echo VERSION: $(VERSION)
	@echo REPO_OWNER: $(REPO_OWNER)
	@echo ALL_PACKAGES: $(ALL_PACKAGES)

go-build:			## Build all binary OS versions
go-build:
	GOOS=linux GOARCH=amd64 $(CC) build -a -o ./bld/$(APP_NAME).linux-amd64 -ldflags='-s -w -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Version=$(VERSION) -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Buildtime=$(BUILD_TIME)' ./
	GOOS=darwin GOARCH=amd64 $(CC) build -a -o ./bld/$(APP_NAME).darwin-amd64 -ldflags='-s -w -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Version=$(VERSION) -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Buildtime=$(BUILD_TIME)' ./
	GOOS=windows GOARCH=amd64 $(CC) build -a -o ./bld/$(APP_NAME).windows-amd64.exe -ldflags='-s -w -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Version=$(VERSION) -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Buildtime=$(BUILD_TIME)' ./

go-clean:			## Cleans the build cache
go-clean:
	@echo " > Cleaning build cache"

go-get:				## Retrieve missing dependencies
go-get:
	@echo " > Checking if there is any missing dependencies..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go get $(get)




