#
# Oracle Server JRE
#

#
FROM tekii/debian:wheezy

MAINTAINER Pablo Jorge Eduardo Rodriguez <pr@tekii.com.ar>

LABEL version=__VERSION__

USER __USER__

RUN mkdir --parents __INSTALL__ && \
    apt-get --quiet=2 update && \
    apt-get --quiet=2 install --assume-yes --no-install-recommends wget && \
    echo "start downloading and decompressing __LOCATION__/__TARBALL__" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie" -q -O - __LOCATION__/__TARBALL__ | tar -xz --strip=1 -C __INSTALL__ && \
    echo "end downloading and decompressing." && \
    chown --recursive __USER__:__GROUP__ __INSTALL__ && \
    update-alternatives --install /usr/bin/java java __INSTALL__/bin/java 100 && \
    __INSTALL__/bin/keytool -keystore __INSTALL__/jre/lib/security/cacerts -importcert -alias dst_root_ca_X3_letsencrypt -file /usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt -storepass changeit -noprompt && \
    apt-get --quiet=2 purge --assume-yes wget && \
    apt-get --quiet=2 autoremove --assume-yes && \
    apt-get --quiet=2 clean && \
    apt-get --quiet=2 autoclean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV JAVA_HOME __INSTALL__
