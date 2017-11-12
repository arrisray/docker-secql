FROM arris/vscode:latest
MAINTAINER Arris Ray <arris.ray@gmail.com>

# Args
ARG USER=developer
ARG GROUP=dev
ARG UID=1000
ARG GID=1000
ARG CODE_DIR=/opt/code
ARG PROJECT_DIR=${CODE_DIR}/src/github.com/user/repo
ARG USER_PWD=${USER}
ARG ROOT_PWD=root
ARG VERSION=1.9.2
ARG OS=linux
ARG ARCH=amd64

# Envs
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH=${CODE_DIR}
ENV DATA_DIR=${HOME}/.vscode

# Configure users
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

# Configure env
USER ${USER}
ENV HOME /home/${USER}
WORKDIR ${HOME}

# Configure VS Code
COPY ./settings/settings.json ${DATA_DIR}/User
RUN sudo mkdir -p ${GOPATH}/.vscode/User \
    && sudo chown -R ${USER}:${GROUP} \
        ${GOPATH} \
        /usr/local \
        ${DATA_DIR} \
        /tmp \
    && wget -nc https://redirector.gvt1.com/edgedl/go/go${VERSION}.${OS}-${ARCH}.tar.gz \
    && wget -nc https://github.com/golang/dep/releases/download/v0.3.2/dep-linux-amd64 \
        && cp dep-linux-amd64 /usr/local/go/bin/dep \
        && chmod +x /usr/local/go/bin/dep \
	&& tar -C /usr/local -xzf go${VERSION}.${OS}-${ARCH}.tar.gz \
    && code --install-extension lukehoban.Go --user-data-dir=${DATA_DIR} \
    && code --install-extension vscodevim.vim --user-data-dir=${DATA_DIR} 

# Configure project
WORKDIR ${PROJECT_DIR}
COPY Gopkg.* ${PROJECT_DIR}/
RUN dep ensure --vendor-only

# Run
CMD code --wait --user-data-dir=$DATA_DIR

