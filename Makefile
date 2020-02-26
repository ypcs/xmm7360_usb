obj-m := xmm7360_usb.o

VERSION ?= $(shell cat xmm7360_usb.c |grep ^MODULE_VERSION |sed 's/MODULE_VERSION("\(.*\)");/\1/g')
KVERSION ?= $(shell uname -r)
KDIR := /lib/modules/$(KVERSION)/build
PWD := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

dkms.conf: dkms.conf.in
	sed 's/PACKAGE_VERSION=.*/PACKAGE_VERSION=$(VERSION)/g' $< > $@

clean:
	rm -f dkms.conf
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install

load:
	-/sbin/rmmod xmm7360
	/sbin/insmod xmm7360.ko

dkms-add:
	/usr/sbin/dkms add $(CURDIR)

dkms-build: dkms.conf
	/usr/sbin/dkms build -c dkms.conf -m xmm7360_usb -v $(VERSION) -k $(KVERSION)

dkms-remove:
	/usr/sbin/dkms remove xmm7360_usb -v $(VERSION) -k $(KVERSION)


dkms-deb: dkms-build
	/usr/sbin/dkms mkdeb -m xmm7360_usb -v $(VERSION) -k $(KVERSION)
