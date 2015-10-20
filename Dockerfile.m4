#
# Oracle Server JRE
#

#
FROM tekii/debian:wheezy

MAINTAINER Pablo Jorge Eduardo Rodriguez <pr@tekii.com.ar>

LABEL version=__VERSION__

USER __USER__

RUN mkdir --parents __INSTALL__ && \
    apt-get update && \
    apt-get install --assume-yes --no-install-recommends wget ca-certificates && \
    echo "start downloading and decompressing __LOCATION__/__TARBALL__" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie" -q -O - __LOCATION__/__TARBALL__ | tar -xz --strip=1 -C __INSTALL__ && \
    echo "end downloading and decompressing." && \
    chown --recursive __USER__:__GROUP__ __INSTALL__ && \
    update-alternatives --install /usr/bin/java java __INSTALL__/bin/java 100 && \
    __INSTALL__/bin/keytool -keystore __INSTALL__/jre/lib/security/cacerts -importcert -alias digicert_ca -file /usr/local/share/ca-certificates/DigiCertCA.crt -storepass changeit -noprompt && \
    apt-get purge --assume-yes wget && \
    apt-get clean autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV JAVA_HOME __INSTALL__
