FROM jenkinsci/blueocean:latest

USER root

RUN apk add --no-cache --update \
	python \
	python-dev \
	py-pip \
	build-base \
	libc6-compat

RUN pip install --upgrade pip

RUN apk add --no-cache --update \
	make \
	libstdc++ \
	build-dependencies libffi-dev openssl-dev

RUN pip install virtualenv && rm -rf /var/cache/apk/*

USER jenkins
