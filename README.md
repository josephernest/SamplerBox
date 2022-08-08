SamplerBox
==========

*Update: [Remove drums from song](https://www.yellownoiseaudio.com) with the VST DrumExtract!*

&nbsp;

SamplerBox is an **open-source DIY audio sampler project** based on RaspberryPi.

Website: [www.samplerbox.org](https://www.samplerbox.org)

[![](https://gget.it/flurexml/1.jpg)](https://www.youtube.com/watch?v=yz7GZ8YOjTw)

[Install](#install)
----

SamplerBox works with the RaspberryPi's built-in soundcard, but it is recommended to use a USB DAC (PCM2704 USB DAC for less than 10€ on eBay is fine) for better sound quality.

1. Install the required dependencies (Python-related packages and audio libraries):

  ~~~
  sudo apt-get update ; sudo apt-get -y install git python-dev python-pip python-numpy cython python-smbus libportaudio2 libffi-dev
  sudo pip install rtmidi-python cffi sounddevice
  ~~~

2. Download SamplerBox and build it with:

  ~~~
  git clone https://github.com/josephernest/SamplerBox.git ;
  cd SamplerBox ; make 

3. Run the soft with `python samplerbox.py`.

4. Play some notes on the connected MIDI keyboard, you'll hear some sound!

*(Optional)*  Modify `samplerbox.py`'s first lines if you want to change root directory for sample-sets, default soundcard, etc.


[How to use it](#howto)
----

See the [FAQ](https://www.samplerbox.org/faq) on https://www.samplerbox.org.


[ISO image](#isoimage)
----

The ready-to-use ISO images available on [www.samplerbox.org](https://www.samplerbox.org) are built with the help of a script that can be found in `isoimage/samplerbox_iso_maker.sh`.


[About](#about)
----

Author : Joseph Ernest (twitter: [@JosephErnest](https:/twitter.com/JosephErnest), mail: [contact@samplerbox.org](mailto:contact@samplerbox.org))


[Sponsors and consulting](#sponsors)
----

I am available for Python, Data science, ML, Automation **consulting**. Please contact me on https://afewthingz.com for freelancing requests.

Do you want to support the development of my open-source projects? Please contact me!

I am currently sponsored by [CodeSigningStore.com](https://codesigningstore.com). Thank you to them for providing a DigiCert Code Signing Certificate and supporting open source software.


[License](#license)
----

[Creative Commons BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/)
