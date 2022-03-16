FROM openjdk:latest
    
#RUN yum install curl

RUN yum install -y libxml2-utils
# RUN apt-get install -y python
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]