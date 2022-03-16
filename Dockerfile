FROM debian:9.5-slim
    
#RUN yum install curl
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get install oracle-java8-installer
RUN apt-get install openjdk-8-jdk
RUN apt-get install python


# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]