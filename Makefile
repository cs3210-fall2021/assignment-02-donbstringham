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
REPO_OWNER ?= $(shell cd .. && basename "$$(pwd)")
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
bld:
bld: go-install go-build

clean: 				## Clean project directories
clean: go-clean
	@echo " > Cleaning bin directory..."
	-rm -r ./bin

info:				## Present version, owner and packages
info:
	@echo VERSION: $(VERSION)
	@echo REPO_OWNER: $(REPO_OWNER)
	@echo ALL_PACKAGES: $(ALL_PACKAGES)

go-build:			## Build all binary OS versions
go-build:
	@echo " > Building all OS binaries..."
	GOOS=linux GOARCH=amd64 $(CC) build -a -o $(GOBIN)/$(APP_NAME).linux-amd64 -ldflags='-s -w -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Version=$(VERSION) -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Buildtime=$(BUILD_TIME)' ./
	GOOS=darwin GOARCH=amd64 $(CC) build -a -o $(GOBIN)/$(APP_NAME).darwin-amd64 -ldflags='-s -w -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Version=$(VERSION) -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Buildtime=$(BUILD_TIME)' ./
	GOOS=windows GOARCH=amd64 $(CC) build -a -o $(GOBIN)/$(APP_NAME).windows-amd64.exe -ldflags='-s -w -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Version=$(VERSION) -X github.com/$(REPO_OWNER)/$(APP_NAME)/ver.Buildtime=$(BUILD_TIME)' ./

go-clean:			## Cleans the build cache
go-clean:
	@echo " > Cleaning build cache..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) $(CC) clean

go-get:				## Retrieve missing dependencies
go-get:
	@echo " > Checking if there is any missing dependencies..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) $(CC) get $(get)

go-install:			## Install all dependencies
go-install:
	@echo " > Installing dependencies..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) $(CC) install $(ALL_PACKAGES)

