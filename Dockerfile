FROM arris/vscode:latest
MAINTAINER Arris Ray <arris.ray@gmail.com>

ARG VERSION=1.9.2
ARG OS=linux
ARG ARCH=amd64
ARG CODE_DIR=/opt/code
ARG USER_DATA_DIR_ARG=--user-data-dir=${CODE_DIR}

USER root

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH=${CODE_DIR}

RUN wget https://redirector.gvt1.com/edgedl/go/go${VERSION}.${OS}-${ARCH}.tar.gz \
	&& tar -C /usr/local -xzf go${VERSION}.${OS}-${ARCH}.tar.gz \
    && code --install-extension lukehoban.Go --user-data-dir=${CODE_DIR}

CMD code --wait --user-data-dir=${CODE_DIR} 
