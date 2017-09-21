FROM ubuntu:14.04
RUN export DEBIAN_FRONTEND="noninteractive"
RUN apt-get update
RUN apt-get install -y apt-file && apt-file update
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:securityonion/stable
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y securityonion-iso syslog-ng-core
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD sosetup.conf /
RUN sosetup -f /sosetup.conf
CMD ["/bin/bash"]
