
all: build run

build:
	docker build -t fenyoa/angrybirds2-arena-hack .

test:
	docker run --rm -it -p 8888:80 -p 3130:8080 --entrypoint=/bin/sh fenyoa/angrybirds2-arena-hack

run: stop rm
	docker run -d --name ab2 -it -p 8888:8080 fenyoa/angrybirds2-arena-hack

stop:
	-docker stop ab2

rm:
	-docker rm ab2

stop-rm: stop rm
