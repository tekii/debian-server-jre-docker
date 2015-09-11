#
# Google Debian + Oracle Server JRE
#
# http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html
# https://www.oracle.com/webfolder/s/digest/8u51checksum.html
#
# http://download.oracle.com/otn-pub/java/jdk/8u51-b16/server-jre-8u51-linux-x64.tar.gz
#
VERSION:=8u60
TARBALL:=server-jre-$(JDK_VERSION)-linux-x64.tar.gz
LOCATION:=http://download.oracle.com/otn-pub/java/jdk/$(JDK_VERSION)-b27
INSTALL:=/opt/jdk
DOCKER_TAG:=tekii/server-jre

__SRC__:=.
__PATCHED__:=$(__SRC__)/patched

##
## M4
##
M4= $(shell which m4)
M4_FLAGS= -P \
	-D __VERSION__=$(VERSION) \
	-D __DOWNLOAD_URL__=$(LOCATION)/$(TARBALL) \
	-D __INSTALL__=$(INSTALL) \
	-D __DOCKER_TAG__=$(DOCKER_TAG)



$(JDK_TARBALL):
	wget --header "Cookie: oraclelicense=accept-securebackup-cookie" $(JDK_LOCATION)/$(JDK_TARBALL)
	md5sum --check $(JDK_TARBALL).md5

$(__PATCHED__): $(JDK_TARBALL) $(__SRC__)/ca_01_tekii_com_ar.pem $(__SRC__)/ca_03_tekii_com_ar.pem
	mkdir -p $@
	tar zxvf $(JDK_TARBALL) -C $@ --strip-components=1
	$(__PATCHED__)/bin/keytool -keystore $(__PATCHED__)/jre/lib/security/cacerts -importcert -alias tekii_ca_01 -file $(__SRC__)/ca_01_tekii_com_ar.pem -storepass changeit -noprompt
	$(__PATCHED__)/bin/keytool -keystore $(__PATCHED__)/jre/lib/security/cacerts -importcert -alias tekii_ca_03 -file $(__SRC__)/ca_03_tekii_com_ar.pem -storepass changeit -noprompt

PHONY += docker-image $(__PATCHED__)
docker-image: $(__PATCHED__)
# 	the -t do the latest trick...
	docker build -t tekii/debian-server-jre .


PHONY += push-to-docker
push-to-docker: docker-image
	docker push tekii/debian-server-jre

PHONY += push-to-google
push-to-google: docker-image
	docker tag tekii/debian-server-jre gcr.io/mrg-teky/debian-server-jre
	gcloud docker push gcr.io/mrg-teky/debian-server-jre

PHONY += clean
clean:
	rm -rf $(__PATCHED__)

PHONY += realclean
realclean: clean
	rm -f $(JDK_TARBALL)

PHONY += all
all: $(JDK_TARBALL)

.PHONY: $(PHONY)
.DEFAULT_GOAL := all

#/opt/jre/jdk1.8.0_51/bin/keytool -keystore $JAVA_HOME/jre/lib/security/cacerts -importcert -alias TEKii_CA_03 -file /tmp/ca_03_tekii_com_ar.pem -storepass changeit -noprompt
