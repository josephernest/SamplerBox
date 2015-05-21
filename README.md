SamplerBox
==========

An open-source audio sampler project based on RaspberryPi.

[![](http://gget.it/flurexml/1.jpg)](https://www.youtube.com/watch?v=yz7GZ8YOjTw)


[Install](#install)
----

1. Check if the required tools are installed (see [Requirements](#requirements) below).

2. Download SamplerBox and build it with: 

  ~~~
  git clone https://github.com/josephernest/SamplerBox.git ; cd SamplerBox ; sudo python setup.py build_ext --inplace
  ~~~

3. Run the soft with `python samplerbox.py`.

4. Play some notes on the connected MIDI keyboard, you'll hear some sound!  

  *Important note: it's not going to work with RaspberryPi's built-in soundcard: it will produce bad sound quality, and more annoying: lags/jitter. You do need a DAC such as [this one](http://www.ebay.fr/itm/1Pc-PCM2704-5V-Mini-USB-Alimente-Sound-Carte-DAC-decodeur-Board-pr-ordinateur-PC-/231334667385?pt=LH_DefaultDomain_71&hash=item35dc9ee479) to have normal audio output.*

*(Optional)*  Modify `samplerbox.py`'s first lines if you want to change root directory for sample-sets, default soundcard, etc.

[Requirements](#requirements)
----

You first need a RaspberryPi 2 (untested on RaspberryPi B / B+) and a DAC (i.e. a better soundcard than the built-in one, it costs around [6€](http://www.ebay.fr/itm/1Pc-PCM2704-5V-Mini-USB-Alimente-Sound-Carte-DAC-decodeur-Board-pr-ordinateur-PC-/231334667385?pt=LH_DefaultDomain_71&hash=item35dc9ee479)).

Assuming you are using a Raspbian distribution, you can install the required dependecies this way:

* Python-related packages and audio libraries:

  ~~~
  sudo apt-get update ; sudo apt-get -y install python-dev cython python-smbus portaudio19-dev
  ~~~

* RtMidi-python for MIDI input and PyAudio for audio output:

  ~~~
  git clone https://github.com/superquadratic/rtmidi-python.git ; cd rtmidi-python ; sudo python setup.py install ; cd .. ;
  git clone http://people.csail.mit.edu/hubert/git/pyaudio.git ; cd pyaudio ; sudo python setup.py install ; cd ..
  ~~~

  *Note:* Don't install `pyaudio` with `apt-get install python-pyaudio` since this would install version 0.2.4, that wouldn't work for this project. Version 0.2.8 or higher is required.

  <!-- wget http://ftp.de.debian.org/debian/pool/main/p/python-pyaudio/python-pyaudio_0.2.8-1+b1_armhf.deb ; dpkg -i python-pyaudio_0.2.8-1+b1_armhf.deb -->  

[How to use it](#howto)
----

####1) How to change preset?

Use the buttons you connected to the RaspberryPi's GPIO (as described [here](http://www.samplerbox.org/makeit/)) or send a *Program Change* message with your MIDI keyboard.

####2) How to create a new sample-set?

* First create a new folder beginning with a number (in the range 0-127) + a white space. Example: `3 Grand piano/` or `14 Mellow organ/`
* Put some .WAV files in it. If their name are `%midinote.wav` (example: 36.wav, 37.wav, ..., 60.wav for middle C of the keyboard), there's nothing else to do!
* *(Optional)* If the filenames of the .WAV files are more complex, create a *sample-set definition file* in the sample-set folder, like this: `3 Grand piano/3.txt`. More details soon.

<!-- [Advanced usage](#advanced)

####7-segment display via I2C

To use a 7-segment display via I2C, you need to first enable I2C via `raspi-config`, then `8 Advanced options` then `I2C` or by modifying manually `/boot/config.txt`. Then `modprobe i2c-dev`  (or /etc/modules-load.d/raspberry.conf => add: i2c-dev) is still required. (Why?)
Then `sudo` will be required on `python samplerbox.py` in order that python can write on I2C port.
-->


[About](#about)
----

Author : Joseph Ernest (twitter: [@JosephErnest](http:/twitter.com/JosephErnest), mail: [contact@samplerbox.org](mailto:contact@samplerbox.org))


[License](#license)
----

[Creative Commons BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/)
