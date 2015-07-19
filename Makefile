#
# Google Debian + Oracle Server JRE
#
# http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html
# https://www.oracle.com/webfolder/s/digest/8u51checksum.html
#
# http://download.oracle.com/otn-pub/java/jdk/8u51-b16/server-jre-8u51-linux-x64.tar.gz
#
JDK_TARBALL:=server-jre-8u51-linux-x64.tar.gz
JDK_LOCATION:=http://download.oracle.com/otn-pub/java/jdk/8u51-b16

$(JDK_TARBALL):
	wget --header "Cookie: oraclelicense=accept-securebackup-cookie" $(JDK_LOCATION)/$(JDK_TARBALL)
	md5sum --check $(JDK_TARBALL).md5

PHONY += docker-image
docker-image: $(JDK_TARBALL)
	docker build -t tekii/debian-server-jre .


PHONY += push-to-docker
push-to-docker: docker-image
	docker push tekii/debian-server-jre

PHONY += push-to-google
push-to-google: docker-image
	docker tag debian-server-jre gcr.io/test-teky/debian-server-jre
	gcloud docker push gcr.io/test-teky/debian-server-jre

PHONY += clean
clean:
	rm -f $(JDK_TARBALL)

PHONY += all
all: $(JDK_TARBALL)

.PHONY: $(PHONY)
.DEFAULT_GOAL := all
