
all:

cache:
	mkdir cache

webdocs:
	mkdir webclone

webdocs/pinout.xyz: 
	wget -P webdocs -E -H -k -K -p 'https://pinout.xyz/pinout/inky_impression#'

cache/Armbian_23.02.0-trunk_Bananapim2zero_sid_edge_6.1.9.img:
	wget 'https://github.com/armbian/community/releases/download/202306/Armbian_23.02.0-trunk_Bananapim2zero_sid_edge_6.1.9.img.xz#bananapim2zero'
	unxz Armbian_23.02.0-trunk_Bananapim2zero_sid_edge_6.1.9.img.xz
	mv Armbian_23.02.0-trunk_Bananapim2zero_sid_edge_6.1.9.img cache/

.PHONY: writesd
writesd:
	sudo dd if=cache/Armbian_23.02.0-trunk_Bananapim2zero_sid_edge_6.1.9.img of=/dev/mmcblk0 bs=10M status=progress
	sync

.PHONY: bkupimg
bkupimg:
	echo about 840 seconds
	sudo dd of=images/imgbkup.img if=/dev/mmcblk0 bs=10M status=progress
	sync

.PHONY: mountsd
mountsd:
	fdisk -l cache/Armbian_23.02.0-trunk_Bananapim2zero_sid_edge_6.1.9.img 
	sudo mount -t auto -o loop,offset=$$(( 512 * 8192 )) cache/Armbian_23.02.0-trunk_Bananapim2zero_sid_edge_6.1.9.img /mnt

.PHONY: umountsd
umountsd:
	sudo umount /mnt
	sync

.PHONY: updatefs
updatefs: /mnt/etc
ifdef SSID
	m4 -DSSID=$$SSID -DPSK=$$PSK fs/wlan.m4 > fs/wlan
	@cat fs/wlan
	sudo cp fs/wlan /mnt/etc/network/interfaces.d/wlan
	rm fs/wlan
	sudo cp fs/armbianEnv.txt /mnt/boot
else
	@echo 'please set $SSID and $PSK and try again'
endif


