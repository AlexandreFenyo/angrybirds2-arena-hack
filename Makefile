
all: build run

build:
	docker build -t fenyoa/angrybirds2-arena-hack .

test:
	docker run --rm -it -p 8888:80 -p 3130:8080 --entrypoint=/bin/sh fenyoa/angrybirds2-arena-hack

run: stop rm
	docker run -d --name ab2 -it -p 8888:8080 fenyoa/angrybirds2-arena-hack

run-dev: stop rm
	docker run -d --name ab2 -it -p 8888:8080 -v ${PWD}/index.cgi:/var/www/localhost/cgi-bin/index.cgi -v ${PWD}/time.sh:/usr/local/bin/time.sh -v ${PWD}/entrypoint.sh:/usr/local/bin/entrypoint.sh fenyoa/angrybirds2-arena-hack

exec:
	docker exec -it ab2 /bin/zsh

stop:
	-docker stop ab2

rm:
	-docker rm ab2

stop-rm: stop rm

push:
	docker push fenyoa/angrybirds2-arena-hack

