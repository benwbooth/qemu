#!/usr/bin/env bash

exec qemu-system-x86_64 \
-m 8192 \
-enable-kvm \
-cpu host,kvm=off \
-smp cpus=8,cores=8,threads=1,sockets=1 \
-rtc clock=host,base=localtime \
-k en-us \
-smbios type=2 \
-machine q35,accel=kvm,usb=off,vmport=off \
-bios OVMF.windows.fd \
\
-device virtio-scsi-pci,id=scsi \
-drive file=virtio-win-0.1.102.iso,id=virtiocd,if=none,format=raw -device ide-cd,bus=ide.1,drive=virtiocd \
\
-device i82801b11-bridge,id=pci.1,bus=pcie.0,addr=0x1e \
-device pci-bridge,chassis_nr=2,id=pci.2,bus=pci.1,addr=0x1 \
-device ahci,id=sata0,bus=pci.2,addr=0x5 \
\
-drive file=/dev/sdf,if=none,media=disk,id=drive-sata0-1-0,format=raw \
-device ide-hd,bus=sata0.1,drive=drive-sata0-1-0,id=sata0-1-0 \
\
-drive file=/dev/sdd,if=none,media=disk,id=drive-sata0-2-0,format=raw \
-device ide-hd,bus=sata0.2,drive=drive-sata0-2-0,id=sata0-2-0 \
\
-usb \
-device usb-mouse \
-device usb-kbd \
-serial stdio \
-vga none \
\
-usbdevice host:0a5c:21e8 \
-device vfio-pci,host=07:00.0,bus=pcie.0,addr=04.0 \
-device vfio-pci,host=02:00.0,bus=pcie.0,addr=05.0 \
\
-device vfio-pci,host=01:00.0,id=hostdev0,bus=pcie.0,multifunction=on \
-device vfio-pci,host=01:00.1,bus=pcie.0 \

-device qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vgamem_mb=16 \
-spice port=5930,disable-ticketing \

-drive file=Win10_1511_1_English_x64.iso,id=isocd,format=raw,if=none -device scsi-cd,drive=isocd,bootindex=1 \

-net nic \
-net bridge,br=br0 \
