DATE_TAG := $(shell date +%Y%m%d%H%M%S)
IMAGE_NAME := yautz/pg_tool
IMAGE_VERSION ?= latest
FULL_TAG := $(IMAGE_NAME):$(DATE_TAG)
LATEST_TAG := $(IMAGE_NAME):latest

build:
	docker build --no-cache \
		-t $(FULL_TAG) \
		-t $(LATEST_TAG) \
		--build-arg IMAGE_VERSION=$(IMAGE_VERSION) \
		-f Dockerfile.tool .

push: build
	docker push $(FULL_TAG)
	docker push $(LATEST_TAG)
