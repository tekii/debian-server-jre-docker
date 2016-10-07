#
# Oracle Server JRE
#

#
FROM tekii/debian:wheezy

MAINTAINER Pablo Jorge Eduardo Rodriguez <pr@tekii.com.ar>

LABEL version=8u60

USER root

#COPY chain.crt /usr/local/share/ca-certificates/

RUN mkdir --parents /opt/jdk && \
    apt-get --quiet=2 update && \
    apt-get --quiet=2 install --assume-yes --no-install-recommends wget && \
    echo "start downloading and decompressing http://download.oracle.com/otn-pub/java/jdk/8u60-b27/server-jre-8u60-linux-x64.tar.gz" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie" -q -O - http://download.oracle.com/otn-pub/java/jdk/8u60-b27/server-jre-8u60-linux-x64.tar.gz | tar -xz --strip=1 -C /opt/jdk && \
    echo "end downloading and decompressing." && \
    chown --recursive root:root /opt/jdk && \
    update-alternatives --install /usr/bin/java java /opt/jdk/bin/java 100 && \
    /opt/jdk/bin/keytool -keystore /opt/jdk/jre/lib/security/cacerts -importcert -alias letsencrypt_chain -file /usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt -storepass changeit -noprompt && \
    apt-get --quiet=2 purge --assume-yes wget && \
    apt-get --quiet=2 autoremove --assume-yes && \
    apt-get --quiet=2 clean && \
    apt-get --quiet=2 autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV JAVA_HOME /opt/jdk
