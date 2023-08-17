FROM registry.access.redhat.com/ubi9/ubi
MAINTAINER Misha Ramendik <mramendi@redhat.com>

# Install packages for both Python running and image building
RUN yum -y update
RUN yum -y install python3-pip git sudo

# Create the syncserver user for running CI processes
RUN useradd -m syncserver

# Provide the Aura package for Python
COPY aura.tar.gz /home/syncserver

# Provide the script to install RH certs and enable running it sudo
COPY install-cert /usr/local/bin
COPY sudoers /etc

# test to see if the build has happened
COPY sudoers /home/syncserver

# Run commands as user - this also makes syncserver the default user for CI
USER syncserver

# Configure git
RUN git config --global user.email "mramendi@redhat.com"
RUN git config --global user.name "sync bot"
RUN git config --global push.autoSetupRemote true

# Install necessary Python packages
RUN pip3 install pyyaml /home/syncserver/aura.tar.gz
