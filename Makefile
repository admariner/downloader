#

# Makefile for the downloader service.
#
# SYNOPSIS:
#
#   make             - format and compile the entire program along with its dependencies
#   make fmt         - run gofmt to report any code formatting errors
#   make deps        - verify consistency of `vendor/` directory contents
#   make build       - compile the program but not install the results
#   make check       - run the package's test suite
#   make install     - compile the program and create the executables
#   make clean       - remove all files generated by building the program
#   make distclean   - remove all files generated by make
#   make lint        - run golint linter on source code
#   make vet         - run the Go vet command on source code

#

.PHONY: install fmt deps build check install clean distclean lint vet

all: fmt build

fmt:
	@if [ -n "$(shell gofmt -l . | grep -v vendor/)" ]; then \
		echo "Source code needs re-formatting! Use 'go fmt' manually."; \
		false; \
	fi

deps:
	dep ensure -v

build: deps
	go build

check: build
	go test -race -p 1 ./...

install: all
	go install -v

clean:
	rm -rf vendor/
	go clean

distclean: clean
	go clean -i -cache -testcache

lint:
	golint ./...

vet:
	go vet ./...
