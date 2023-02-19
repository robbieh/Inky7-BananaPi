
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
```

Edit `debian_bookworm/control` and change the `Build-Depends` line for rpi.gpio:

```
Build-Depends: debhelper (>= 11~), dh-python, python3-all, python3-all-dev, python3-setuptools
```

Edit `debian_bookworm/changelog` and change the instance of `buster` to `bookworm`

Edit `debian_bookworm/rules` and reomve `python2,` from the last line.

Edit `make_deb` and change the one instance of python to python3. Then follow up with:

```
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
apt install python3-numpy python3-spidev python3-bs4 python3-smbus2 python3-rpi.gpio python3-future python3-requests

pip3 install --break-system-packages inky[rpi,example-depends]
```

Then edit `/root/.local/lib/python3.11/site-packages/inky/inky_uc8159.py` and comment out the `self._spi_bus.no_cs` line (line 229 in this case).


Using the Inky Library
======================
I found the wrong i2c bus was being used. So it has to be specified when initializing the inky library.

Here's how that looks:
```
display = auto(i2c_bus=SMBus(0))
with Image.open("image.png") as im:
	imresized = im.resize((display.width, display.height))
	display.set_image(imresized)
	display.show()
```
