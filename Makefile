.PHONY=(all build reconfigure)

ifeq ($(shell uname -s),Darwin)
	SED=sed -i ''
else
	SED=sed -i
endif

OVS_VERSIONS = \
	"2.4.0" \
	"2.5.8"

all: reconfigure build

reconfigure:
	for v in ${OVS_VERSIONS} ; do \
		echo "====> Reconfiguring $$v" ; \
		rm -r $$v ; \
		mkdir -p $$v ; \
		cp supervisord.conf $$v/ ; \
		cp configure-ovs.sh $$v/ ; \
		cp Dockerfile $$v/ ; \
		args="s/$(shell cat latest)/$$v/g" ; \
		cmd="${SED} $$args $$v/Dockerfile" ; \
		eval $$cmd ; \
	done

build:
	for v in ${OVS_VERSIONS} ; do \
		echo "====> Building blackplane/openvswitch:$$v" ; \
		docker build -t blackplane/openvswitch:$$v $$v ; \
	done
