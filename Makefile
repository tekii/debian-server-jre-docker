##
## Google Debian + Oracle Server JRE
##
## http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html
## https://www.oracle.com/webfolder/s/digest/8u51checksum.html
## http://download.oracle.com/otn-pub/java/jdk/8u51-b16/server-jre-8u51-linux-x64.tar.gz
## http://javadl.oracle.com/webapps/download/AutoDL?BundleId=220305_d54c1d3a095b4ff2b6607d096fa80163
##
VERSION:=8u131
TARBALL:=AutoDL?BundleId=220305_d54c1d3a095b4ff2b6607d096fa80163
LOCATION:=http://javadl.oracle.com/webapps/download
SHA256:=899d9f09d7c1621a5cce184444b0ba97a8b0391bd85b624ea29f81a759764c55
INSTALL:=/opt/jdk
TAG:=gcr.io/mrg-teky/server-jre
USER:=root
GROUP:=root

##
## M4
##
M4= $(shell which m4)
M4_FLAGS= -P \
	-D __VERSION__=$(VERSION) \
	-D __TARBALL__=$(TARBALL) \
	-D __LOCATION__=$(LOCATION) \
	-D __SHA256__=$(SHA256) \
	-D __INSTALL__=$(INSTALL) \
	-D __USER__=$(USER) \
	-D __GROUP__=$(GROUP) \
	-D __TAG__=$(TAG)

$(TARBALL):
#	wget --header "Cookie: oraclelicense=accept-securebackup-cookie" $(LOCATION)/$(TARBALL)
	echo "$(SHA256) $(TARBALL)" > $(TARBALL).sha256
	sha256sum --check $@.sha256

#.SECONDARY
Dockerfile: Dockerfile.m4 Makefile
	$(M4) $(M4_FLAGS) $< >$@

cloudbuild.yaml: m4/cloudbuild.yaml Makefile
	$(M4) $(M4_FLAGS) $< >$@

PHONY += image
image: Dockerfile cloudbuild.yaml
	docker build --no-cache=false --rm=true --tag $(TAG) .

PHONY += push-to-google
push-to-google: docker-image
	docker tag $(TAG) gcr.io/mrg-teky/server-jre
	gcloud docker push gcr.io/mrg-teky/server-jre

PHONY += git-tag git-push
git-tag:
	-git tag -d $(VERSION)
	git tag $(VERSION)

git-push:
	-git push origin :refs/tags/$(VERSION)
	git push origin
	git push --tags origin

PHONY += clean
clean:
	rm -f *.sha256
	rm -f *.md5

PHONY += realclean
realclean: clean
	rm -f server-jre-*.tar.gz

PHONY += all
all: image

.PHONY: $(PHONY)
.DEFAULT_GOAL := all
