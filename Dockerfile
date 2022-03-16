FROM debian:9.5-slim
    
#RUN yum install curl
RUN sudo apt-get install openjdk-8-jdk
RUN  apt -y upgrade


# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]