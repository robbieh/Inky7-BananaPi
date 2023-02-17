
Install packages
================
As root:
```
sudo apt-get install tmux gcc devscripts build-essential debhelper fakeroot dh-make dh-python python3-dev python3-setuptools python3-pip python3-dev python3-numpy python3-spidev python3-smbus2 python3-pil python3-all python3-all-dev 
```

Prep environment
================
Run `sudo armbian-config` and navigate to System > Hardware. Enable `spi-spidev` and `i2c` here.

Change hostname in `/etc/hostname` if preferred.

Reboot

Fetch and install updated RPi.GPIO
==================================
As root:
```
mkdir Git
mkdir -p ~/.local/lib/python3.11/site-packages/
cd Git
git clone https://github.com/GrazerComputerClub/RPi.GPIO
cp -r debian_buster debian_bookworm
./make_deb
cp -r RPi ~/.local/lib/python3.11/site-packages/
```

Fetch and fix Inky library
==========================
It seems there is a disagreement between the Armbian kernel and the Inky library regarding the presence of `chip select` capability. If you don't edit this out, you'll get an error such as:
```
File "/root/.local/lib/python3.11/site-packages/inky/inky_uc8159.py", line 229, in setup
    self._spi_bus.no_cs = True
    ^^^^^^^^^^^^^^^^^^^
OSError: [Errno 22] Invalid argument
```

As root:
```
pip3 install --break-system-packages inky[rpi,example-depends]
```

Then edit `/root/.local/lib/python3.11/site-packages/inky/inky_uc8159.py` and comment out the `self._spi_bus.no_cs` line (line 229 in this case).



