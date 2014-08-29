MKIMAGE=$(TOP)/uboot-flasher/_build/jetson-tk1/u-boot/tools/mkimage

boot.scr.uimg: boot.scr
	$(MKIMAGE) -A arm -O linux -T script -C none -a 0 -e 0 -d $< $(TOP)/out/$@
