#
# Oracle Server JRE
#

#
FROM launcher.gcr.io/google/debian8:latest

MAINTAINER Pablo Jorge Eduardo Rodriguez <pr@tekii.com.ar>

LABEL version=8u131

USER root

RUN mkdir --parents /opt/jdk && \
    apt-get --quiet=2 update && \
    apt-get --quiet=2 install --assume-yes --no-install-recommends wget && \
    echo "start downloading and decompressing http://javadl.oracle.com/webapps/download/AutoDL?BundleId=220305_d54c1d3a095b4ff2b6607d096fa80163" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie" -q -O - http://javadl.oracle.com/webapps/download/AutoDL?BundleId=220305_d54c1d3a095b4ff2b6607d096fa80163 | tar -xz --strip=1 -C /opt/jdk && \
    echo "end downloading and decompressing." && \
    chown --recursive root:root /opt/jdk && \
    update-alternatives --install /usr/bin/java java /opt/jdk/bin/java 100 && \
    /opt/jdk/bin/keytool -keystore /opt/jdk/lib/security/cacerts -importcert -alias dst_root_ca_X3_letsencrypt -file /usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt -storepass changeit -noprompt && \
    apt-get --quiet=2 purge --assume-yes wget && \
    apt-get --quiet=2 autoremove --assume-yes && \
    apt-get --quiet=2 clean && \
    apt-get --quiet=2 autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV JAVA_HOME /opt/jdk
