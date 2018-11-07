FROM jenkins/base-ubuntu

# --------------------------------------------------
# ----- Nexell added by suker@nexell.co.kr ---------
# --------------------------------------------------
USER root

# repo install
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/local/bin/repo
RUN chmod 755 /usr/local/bin/repo

# apt-utils
#RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl && rm -rf /var/lib/apt/lists/*

# Yocto build env
RUN apt-get update && apt-get install -y gawk git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio bc
RUN apt-get update && apt-get install -y autoconf automake libtool libglib2.0-dev libarchive-dev
RUN apt-get update && apt-get install -y python-git

# other
RUN apt-get update && apt-get install -y lzop rsync

# cross toolchain
RUN apt-get update && apt-get install -y lynx device-tree-compiler

ENV CROSSTOOLS /opt/crosstools
ENV TOOLCHAIN_ARM_CORTEX_A9 ${CROSSTOOLS}/arm-cortex_a9-eabi-4.7-eglibc-2.18
ENV TOOLCHAIN_GCC_LINARO_AARCH64 ${CROSSTOOLS}/gcc-linaro-4.9-2015.05-x86_64_aarch64-linux-gnu
ENV TOOLCHAIN_ARM_EABI ${CROSSTOOLS}/arm-eabi-4.8

RUN mkdir -p ${CROSSTOOLS}

COPY arm-cortex_a9-eabi-4.7-eglibc-2.18-splita* ${CROSSTOOLS}/
COPY gcc-linaro-4.9-2015.05-x86_64_aarch64-linux-gnu-splita* ${CROSSTOOLS}/
COPY arm-eabi-4.8.tar.gz ${CROSSTOOLS}

RUN mkdir -p ${TOOLCHAIN_ARM_CORTEX_A9}
RUN mkdir -p ${TOOLCHAIN_GCC_LINARO_AARCH64}
RUN mkdir -p ${TOOLCHAIN_ARM_EABI}

RUN cat /opt/crosstools/arm-cortex_a9-eabi-4.7-eglibc-2.18-splita* | tar -zxvpf - -C ${CROSSTOOLS}
RUN cat /opt/crosstools/gcc-linaro-4.9-2015.05-x86_64_aarch64-linux-gnu-splita* | tar -zxvpf - -C ${CROSSTOOLS}
RUN tar xvzf /opt/crosstools/arm-eabi-4.8.tar.gz -C ${TOOLCHAIN_ARM_EABI}

RUN mkdir -p /tmp/nexell_conf/build_rule
RUN mkdir -p /tmp/nexell_conf/backup_conf
RUN mkdir -p /tmp/nexell_conf/jobs
COPY build_rule /tmp/nexell_conf/build_rule
#COPY backup_conf /tmp/nexell_conf/backup_conf
#COPY jobs /tmp/nexell_conf/jobs

# Android BUILD
# Install dependencies
RUN dpkg --add-architecture i386 && \
      apt-get update && \
      apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
      apt-get clean

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH
ENV JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4096m"
ENV USER "jenkins"

# License Id: android-sdk-license-ed0d0a5b
ENV ANDROID_COMPONENTS platform-tools,build-tools-23.0.3,build-tools-24.0.0,build-tools-24.0.2,android-23,android-24
# License Id: android-sdk-license-5be876d5
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}" ; \
    echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"

# Support Gradle
ENV TERM dumb

RUN apt-get update && apt-get install -y git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
  libgl1-mesa-dev libxml2-utils xsltproc unzip vim

# ssh client
# ssh-keygen necessary in docker container
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir -p /var/jenkins_home/.ssh
COPY ssh_config /var/jenkins_home/.ssh/config

# scripts
RUN mkdir -p /var/jenkins_home/scripts
COPY scripts/* /var/jenkins_home/scripts/

COPY BUILD-INFO.txt /tmp/nexell_conf/BUILD-INFO.txt

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN echo "jenkins:jenkins" | chpasswd

EXPOSE 8080
EXPOSE 50000

RUN /usr/local/bin/install-plugins.sh \
  gerrit-trigger \
  ws-cleanup \
  thinBackup \
  gerrit \
  git \
  git-client \
  publish-over-ssh \
  text-finder \
  log-parser \
  saferestart \
  PrioritySorter \
  email-ext
# --------------------------------------------------

RUN apt-get update && apt-get install -y python-pip sudo
RUN pip install --upgrade pip
RUN pip install pycrypto

USER jenkins
