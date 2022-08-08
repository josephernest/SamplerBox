#!/bin/bash -v
# The script takes a standard RaspiOS Lite image, installs SamplerBox on it, and creates a ready-to-use image
# Requirement before using: sudo apt update && sudo apt install -y kpartx parted zip
#
# SamplerBox (https://www.samplerbox.org)
# License: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) (https://creativecommons.org/licenses/by-nc-sa/4.0/)

set -e  # exit immediately if a command exits with a non-zero status
# unzip 2021-05-07-raspios-buster-armhf-lite.zip
cp 2021-05-07-raspios-buster-armhf-lite.img sb.img
truncate -s 2500M sb.img      #  M=power of 1024
kpartx -av sb.img
parted -m /dev/loop0 resizepart 2 2499MiB
kpartx -uv /dev/loop0
e2fsck -f /dev/mapper/loop0p2
resize2fs /dev/mapper/loop0p2     # enlarge partition
mkdir -v -p sdcard
mount -v -t ext4 -o sync /dev/mapper/loop0p2 sdcard
mount -v -t vfat -o sync /dev/mapper/loop0p1 sdcard/boot
echo root:root | chroot sdcard chpasswd
chroot sdcard apt update
chroot sdcard apt install -y build-essential python-dev python-pip cython python-smbus python-numpy python-rpi.gpio python-serial portaudio19-dev alsa-utils git libportaudio2 libffi-dev raspberrypi-kernel ntpdate
chroot sdcard pip install rtmidi-python pyaudio cffi sounddevice
chroot sdcard sh -c "cd /root ; git clone https://github.com/josephernest/SamplerBox.git ; cd SamplerBox ; python setup.py build_ext --inplace"
cp -R root/* sdcard
chroot sdcard systemctl enable /etc/systemd/system/samplerbox.service
chroot sdcard systemctl disable systemd-timesyncd systemd-rfkill hciuart raspi-config avahi-daemon resize2fs_once rpi-eeprom-update dphys-swapfile
chroot sdcard systemctl disable regenerate_ssh_host_keys sshswitch
chroot sdcard ssh-keygen -A -v
chroot sdcard systemctl enable ssh
sed -i 's/ENV{pvolume}:="-20dB"/ENV{pvolume}:="-10dB"/' sdcard/usr/share/alsa/init/default
sed -i 's/USE_SERIALPORT_MIDI = False/USE_SERIALPORT_MIDI = True/' sdcard/root/SamplerBox/samplerbox.py
sed -i 's/USE_I2C_7SEGMENTDISPLAY = False/USE_I2C_7SEGMENTDISPLAY = True/' sdcard/root/SamplerBox/samplerbox.py
sed -i 's/USE_BUTTONS = False/USE_BUTTONS = True/' sdcard/root/SamplerBox/samplerbox.py
sed -i 's,SAMPLES_DIR = ".",SAMPLES_DIR = "/media/",' sdcard/root/SamplerBox/samplerbox.py
echo "PermitRootLogin yes" >> sdcard/etc/ssh/sshd_config
echo "alias rw=\"mount -o remount,rw /\"" >> sdcard/root/.bashrc
sync
umount -v sdcard/boot
umount -v sdcard
kpartx -dv sb.img
sync
dd if=sb.img of=/dev/sdd bs=4M status=progress
zip sb.zip sb.img
exit 0
