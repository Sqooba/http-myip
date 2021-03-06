
VERSION=v1.0.0
GOOS=linux
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOLINT=golangci-lint run
VERSION_MAJOR=$(shell echo $(VERSION) | cut -f1 -d.)
VERSION_MINOR=$(shell echo $(VERSION) | cut -f2 -d.)
BINARY_NAME=myip
GO_PACKAGE=touilleio/myip
DOCKER_REGISTRY=
GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_DATE=$(shell date '+%Y-%m-%d-%H:%M:%S')

all: ensure build package

ensure:
	GOOS=${GOOS} $(GOCMD) mod vendor

clean:
	$(GOCLEAN)

lint:
	$(GOLINT) ...

build:
	GOOS=${GOOS} $(GOBUILD) \
		-o ${BINARY_NAME} .

package:
	docker build -f Dockerfile \
	  -t ${DOCKER_REGISTRY}${GO_PACKAGE}:$(VERSION) \
	  -t ${DOCKER_REGISTRY}${GO_PACKAGE}:$(VERSION_MAJOR).$(VERSION_MINOR) \
	  -t ${DOCKER_REGISTRY}${GO_PACKAGE}:$(VERSION_MAJOR) \
	  .

test:
	go test ./...

release:
	docker push ${DOCKER_REGISTRY}${GO_PACKAGE}:$(VERSION)
	docker push ${DOCKER_REGISTRY}${GO_PACKAGE}:$(VERSION_MAJOR).$(VERSION_MINOR)
	docker push ${DOCKER_REGISTRY}${GO_PACKAGE}:$(VERSION_MAJOR)
