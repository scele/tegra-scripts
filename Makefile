MKIMAGE=$(TOP)/uboot-flasher/_build/jetson-tk1/u-boot/tools/mkimage
OUT=$(TOP)/out
HOST_ROOTFS_PATH=$(OUT)/root

$(OUT)/%.scr.uimg: $(OUT)/%.scr
	$(MKIMAGE) -A arm -O linux -T script -C none -a 0 -e 0 -d $< $@

$(OUT)/%.scr: %.scr
	$(eval HOST_IP_ADDRESS := $(shell ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'))
	sed 's/HOST_IP_ADDRESS/$(HOST_IP_ADDRESS)/g;s/HOST_ROOTFS_PATH/$(subst /,\/,$(HOST_ROOTFS_PATH))/g' $< > $@

all: $(OUT)/boot-nfs.scr.uimg $(OUT)/boot.scr.uimg
