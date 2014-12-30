#!/bin/sh

echo "=== 5 steps ==="

# ==================================================
echo "=== 1. Fix the boot partition size ==="
mount /boot
mkdir /tmp/boot
mv /boot/* /tmp/boot
umount /boot
mkfs.vfat /dev/mmcblk0p7
mount /boot
cp /tmp/boot/* /boot
echo "=== 1. Fix the boot partition size === done"

# ==================================================
echo "=== 2. Configure wifi ==="
configure_edison --setup
echo "=== 2. Configure wifi === done"

# ==================================================
echo "=== 3. Config opkg and get some packages ==="
echo "src/gz all http://repo.opkg.net/edison/repo/all" > /etc/opkg/base-feeds.conf
echo "src/gz edison http://repo.opkg.net/edison/repo/edison" >> /etc/opkg/base-feeds.conf
echo "src/gz core2-32 http://repo.opkg.net/edison/repo/core2-32" >> /etc/opkg/base-feeds.conf

opkg update
opkg upgrade

opkg install git cmake wget nano

# === get pip & pyserial ===
mkdir tools_for_python
cd tools_for_python
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install pyserial
cd
echo "=== 3. Config opkg and get some packages === done"

# ==================================================
# ==================================================
# =========== I²C & py-SMBUS for Edison ============
# ==================================================
# ==================================================
echo "=== 4. Enable GPIO 18 & 19 for I²C ==="
echo 28 > /sys/class/gpio/export
echo 27 > /sys/class/gpio/export
echo 204 > /sys/class/gpio/export
echo 205 > /sys/class/gpio/export
echo 236 > /sys/class/gpio/export
echo 237 > /sys/class/gpio/export
echo 14 > /sys/class/gpio/export
echo 165 > /sys/class/gpio/export
echo 212 > /sys/class/gpio/export
echo 213 > /sys/class/gpio/export
echo 214 > /sys/class/gpio/export
echo high > /sys/class/gpio/gpio214/direction
echo high > /sys/class/gpio/gpio204/direction
echo high > /sys/class/gpio/gpio205/direction
echo in > /sys/class/gpio/gpio14/direction
echo in > /sys/class/gpio/gpio165/direction
echo low > /sys/class/gpio/gpio236/direction
echo low > /sys/class/gpio/gpio237/direction
echo in > /sys/class/gpio/gpio212/direction
echo in > /sys/class/gpio/gpio213/direction
echo mode1 > /sys/kernel/debug/gpio_debug/gpio28/current_pinmux
echo mode1 > /sys/kernel/debug/gpio_debug/gpio27/current_pinmux
echo low > /sys/class/gpio/gpio214/direction
echo "=== 4. Enable GPIO 18 & 19 for I²C === done"

# ==================================================
echo "=== 5. download and custom i2c-tools ==="
git clone https://github.com/edouardrosset/i2c-tools.git

cd i2c-tools/
make

# manual install of i2c-tools
cp ./lib/libi2c.so.0.1.0 /usr/lib/
ln -s /usr/lib/libi2c.so.0.1.0 /usr/lib/libi2c.so
ln -s /usr/lib/libi2c.so.0.1.0 /usr/lib/libi2c.so.0 
cp -r ./include/* /usr/include/
cp ./tools/i2cdetect /usr/bin/
cp ./tools/i2cdump /usr/bin/
cp ./tools/i2cget /usr/bin/
cp ./tools/i2cset /usr/bin/

cd ./py-smbus/
python setup.py build
python setup.py install
cd
echo "=== 5. download and custom i2c-tools === done"

# ==================================================
# ==================================================
# ========== workaround to fix bus i2c-6  ==========
# ==================================================
# ==================================================

# // # upload the following on the Quarck of the Arduino /dev/ttyACM0 :
# #include "Wire.h"

# void setup() {
#     Wire.begin();
# }

# void loop() {
#     delay(10000);
# }

