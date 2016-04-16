#!/usr/bin/env bash

exec qemu-system-x86_64 \
-m 8192 \
-enable-kvm \
-cpu core2duo,kvm=off,vendor=GenuineIntel \
-smp cpus=8,cores=8,threads=1,sockets=1 \
-rtc clock=host,base=utc \
-k en-us \
-smbios type=2 \
-machine q35,accel=kvm,usb=off,vmport=off \
-bios OVMF.macosx.fd \
\
-device i82801b11-bridge,id=pci.1,bus=pcie.0,addr=0x1e \
-device pci-bridge,chassis_nr=2,id=pci.2,bus=pci.1,addr=0x1 \
-device ahci,id=sata0,bus=pci.2,addr=0x5 \
\
-drive file=clover-usb-disk.dd,if=none,id=drive-sata0-0-2,format=raw \
-device ide-hd,bus=ide.2,drive=drive-sata0-0-2,id=sata0-0-2,bootindex=1 \
\
-drive file=/dev/sde,if=none,media=disk,id=drive-sata0-1-0,format=raw \
-device ide-hd,bus=sata0.1,drive=drive-sata0-1-0,id=sata0-1-0 \
\
-drive file=/dev/sdg,if=none,media=disk,id=drive-sata0-2-0,format=raw \
-device ide-hd,bus=sata0.2,drive=drive-sata0-2-0,id=sata0-2-0 \
\
-usb \
-device usb-mouse \
-device usb-kbd \
-serial stdio \
-vga none \
\
-usbdevice host:0a5c:21e8 \
-device vfio-pci,host=08:00.0,bus=pci.1,addr=00.0 \
-device vfio-pci,host=09:00.0,bus=pci.1,addr=04.0 \
\
-device vfio-pci,host=03:00.0,id=hostdev0,bus=pcie.0,multifunction=on \
-device vfio-pci,host=03:00.1,bus=pcie.0 \


-drive file=macosx.qcow2,if=none,media=disk,id=drive-sata0-0-0,format=qcow2 \
-device ide-hd,bus=sata0.0,drive=drive-sata0-0-0,id=sata0-0-0 \

#-device isa-applesmc,osk="" \

-device qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vgamem_mb=16 \
-spice port=5930,disable-ticketing \

\
-netdev bridge,id=hn0 \
-device e1000-82545em,netdev=hn0,id=nic1,mac=52:54:00:1d:3a:25 \
