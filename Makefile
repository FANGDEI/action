SHELL = /bin/bash
BIN_NAME := "action"
PKG := "github.com/FANGDEI/action"
PKG_LIST := $(shell go list ${PKG}/... | grep -v /vendor/)
GO_FILES := $(shell find . -name '*.go' | grep -v /vendor/ | grep -v _test.go)
BRANCH := $(shell git branch --no-color 2> /dev/null|sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' -e 's/\//\_/g')
IMAGE_NAME := "fangdei/action:${BRANCH}"

.PHONY: all dep build clean test coverage lint

all: build lint test race coverage

lint: ## Lint the files
	@echo "check lint"
	@golangci-lint run --config ./.golangci.yml

lintfix: ## Lint files and auto fix
	@echo "lint and autofix"
	@golangci-lint run --config ./.golangci.yml --fix

test: ## Run unittests
	@echo "check test"
	@go test -short ${PKG_LIST}

race: ## Run data race detector
	@echo "check race"
	@go test -race -short ${PKG_LIST}

msan: ## Run memory sanitizer
	@echo "check msan"
	#@go test -msan -short ${PKG_LIST}

coverage: ## Generate global code coverage report
	@echo "check coverage"
	#@chmod 755 ./scripts/coverage.sh
	#./scripts/coverage.sh;

dep: ## Get the dependencies
	@echo "check dep"
	@go mod tidy

build: dep ## Build the binary file
	@echo "make build"
	@go build -o $(BIN_NAME) -v main.go

clean: ## Remove previous build
	@echo "make clean"
	@rm -f $(BIN_NAME)

push: clean build ## push image manually
	echo ${BRANCH}
	@echo "make push"
	@docker build . -t $(IMAGE_NAME)
	@docker push $(IMAGE_NAME)

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'