obj-m := xmm7360_usb.o

VERSION ?= $(shell cat xmm7360_usb.c |grep ^MODULE_VERSION |sed 's/MODULE_VERSION("\(.*\)");/\1/g')
KVERSION := $(shell uname -r)
KDIR := /lib/modules/$(KVERSION)/build
PWD := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install

load:
	-/sbin/rmmod xmm7360
	/sbin/insmod xmm7360.ko
