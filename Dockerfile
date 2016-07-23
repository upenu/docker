FROM debian:jessie
MAINTAINER Brian Sang
# install python, git, wget
RUN apt-get update && apt-get install -y python3 python3-dev python3-pip git wget

# install mysql stuff
RUN apt-get update && apt-get install -y mysql-client-5.5, libmysqlclient-dev

# pip3 requirements
RUN wget https://raw.githubusercontent.com/upenu/website/master/requirements.txt
RUN pip3 install -r requirements.txt
RUN /bin/bash -c 'rm requirements.txt;'

