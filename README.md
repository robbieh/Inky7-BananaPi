
What is this?
=============
This is what I did to get the Inky Impression 5.7" screen working with a Banana Pi M2 Zero board.

References
==========
https://pinout.xyz/pinout/inky\_impression#

https://github.com/pimoroni/inky

https://github.com/pimoroni/inky/issues/113

Makefile guide
==============
Running `make` should create a few directories and cache a copy of the Inky pinout webpage as well as download the Armbian release.

Then there are a few handy targets:

* `mountsd`: mount the image as a loopback device so files can be copied to it
* `updatefs`: copies WiFi config and Armbian environment files to the image
* `umountsd`: unmount the image
* `writesd`: writes the sd to /dev/mmcblk0

After booting
=============
Everything else is described in `README_PI.md`

