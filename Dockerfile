#
# Google Debian + Oracle Server JRE
#

# 
FROM google/debian:wheezy

MAINTAINER Pablo Jorge Eduardo Rodriguez <pr@tekii.com.ar>

USER root

RUN mkdir /opt/jdk

COPY ./patched /opt/jdk

RUN chown --recursive root.root /opt/jdk

RUN update-alternatives --install /usr/bin/java java /opt/jdk/bin/java 100

#RUN echo 'JAVA_HOME=/opt/jre/jdk1.8.0_51' >> /etc/environment

ENV JAVA_HOME /opt/jdk

RUN update-alternatives --display java

