#
# Google Debian + Oracle Server JRE
#

# 
FROM google/debian:wheezy

MAINTAINER Pablo Jorge Eduardo Rodriguez <pr@tekii.com.ar>

USER root

RUN mkdir /opt/jre

ADD server-jre-8u51-linux-x64.tar.gz /opt/jre

RUN chown --recursive root.root /opt/jre

RUN update-alternatives --install /usr/bin/java java /opt/jre/jdk1.8.0_51/bin/java 100

#RUN echo 'JAVA_HOME=/opt/jre/jdk1.8.0_51' >> /etc/environment

ENV JAVA_HOME /opt/jre/jdk1.8.0_51

#RUN update-alternatives --display java

