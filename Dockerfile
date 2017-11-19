FROM arris/dev:latest
MAINTAINER Arris Ray <arris.ray@gmail.com>

# Args
ARG USER=developer
ARG GROUP=dev
ARG UID=1000
ARG GID=1000
ARG GOPATH=/opt/code
ARG PROJECT_DIR=src/github.com/user/repo
ARG PROJECT_NS=github.com/user/repo
ARG PROJECT_NAME=repo
ARG USER_PWD=${USER}
ARG ROOT_PWD=root
ARG VERSION=1.9.2
ARG OS=linux
ARG ARCH=amd64

# Envs
ENV HOME /home/${USER}
ENV GOPATH="${GOPATH}"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

# Configure user
# - Add non-privileged user
# - Set non-privileged user's user ID
# - Set non-privileged user's groups (including sudo)
# - Set root user password
# - Set non-privileged user password
# - Allow sudo access without password
RUN id -u ${USER} || \
    ( \
        useradd -m -s /bin/bash ${USER} \
        && usermod -u ${UID} ${USER} \
        && usermod -aG ${GROUP},sudo ${USER} \
        && usermod --password $(openssl passwd -1 ${USER_PWD}) ${USER} \
        && usermod --password $(openssl passwd -1 ${ROOT_PWD}) root \
        && echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    )
USER ${USER}
COPY config/.vimrc ${HOME}/.vimrc

# Configure Go
RUN sudo mkdir -p ${GOPATH} ${GOPATH}/bin \
    && sudo chown -R ${USER}:${GROUP} \
        ${GOPATH} \
        /usr/local \
        /tmp \
    && cd /tmp \
    && wget -nc https://redirector.gvt1.com/edgedl/go/go${VERSION}.${OS}-${ARCH}.tar.gz \
        && tar -C /usr/local -xzf go${VERSION}.${OS}-${ARCH}.tar.gz \
    && wget -nc https://github.com/golang/dep/releases/download/v0.3.2/dep-linux-amd64 \
        && cp dep-linux-amd64 ${GOPATH}/bin/dep \
        && chmod +x ${GOPATH}/bin/dep \
    && cd ${GOPATH} \
        && go get -u golang.org/x/tools/... \
        && go get github.com/derekparker/delve/cmd/dlv && cd src/github.com/derekparker/delve && make install \
    && sudo chown -R ${USER}:${GROUP} ${GOPATH} \
    && vim +PlugInstall +qa
    && go get -u -d github.com/mattes/migrate/cli github.com/go-sql-driver/mysql \
        && go build -tags 'mysql' -o ${GOPATH}/bin/migrate github.com/mattes/migrate/cli 

# Configure project
WORKDIR ${GOPATH}/src/${PROJECT_NS}
EXPOSE 2345 3000

# Run
COPY config/supervisord.conf /etc/supervisord.conf
CMD sudo /usr/bin/supervisord -c /etc/supervisord.conf

