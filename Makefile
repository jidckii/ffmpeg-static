ifeq ($(CPROC),)
CPROC = $(shell nproc)
endif

ifeq ($(FFVERSION),)
FFVERSION = snapshot
endif

.DEFAULT_GOAL := default

.PHONY: build
build:
	docker build \
		--build-arg CPROC=$(CPROC) \
		--build-arg FFMPEG_VERSION=$(FFVERSION) \
		-t jidckii/ffmpeg-static:$(FFVERSION) \
		-f Dockerfile .

.PHONY: copy
copy:
	docker create --name ffmpeg-static-copy jidckii/ffmpeg-static:$(FFVERSION)
	docker cp ffmpeg-static-copy:/usr/local/bin/ffmpeg ./
	docker cp ffmpeg-static-copy:/usr/local/bin/ffprobe ./
	docker rm -f ffmpeg-static-copy

.PHONY: default
default: build
default: copy
