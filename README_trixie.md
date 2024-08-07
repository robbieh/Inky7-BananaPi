
After an `apt-get dist-upgrade` the relase changed from `bookworm` to `trixie`.

Most steps still applied. But the RPi.GPIO package was a problem. I couldn't
build it for Python 3.12. So I clobbered it with the old version from a working
system.

```
cp lib.linux-armv7l-cpython-311/RPi/_GPIO.cpython-311-arm-linux-gnueabihf.so _GPIO.cpython-312-arm-linux-gnueabihf.so
```


Also the network refused to start at boot time, but would work when started
with `ifup`. Adding this to `/etc/rc.local` is OK as workaround:

```
ifdown wlan0
ifup wlan0
```
