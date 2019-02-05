SamplerBox
==========

An open-source audio sampler project based on RaspberryPi.

Website: www.samplerbox.org

[![](http://gget.it/flurexml/1.jpg)](https://www.youtube.com/watch?v=yz7GZ8YOjTw)

[Install](#install)
----

SamplerBox works with the RaspberryPi's built-in soundcard, but it is recommended to use a USB DAC (such as [this 6€ one](http://www.ebay.fr/itm/1Pc-PCM2704-5V-Mini-USB-Alimente-Sound-Carte-DAC-decodeur-Board-pr-ordinateur-PC-/231334667385?pt=LH_DefaultDomain_71&hash=item35dc9ee479)) for better sound quality.

1. Install the required dependencies (Python-related packages and audio libraries):

  ~~~
  sudo apt-get update ; sudo apt-get -y install git python3-dev python3-pip python3-numpy cython3 python3-smbus portaudio19-dev libportaudio2 libffi-dev
  sudo pip3 install rtmidi-python pyaudio cffi sounddevice
  ~~~

2. Download SamplerBox and build it with: 

  ~~~
  git clone https://github.com/josephernest/SamplerBox.git
  cd SamplerBox ; sudo python3 setup.py build_ext --inplace
  ~~~

3. Run the soft with `python3 samplerbox.py`.

4. Play some notes on the connected MIDI keyboard, you'll hear some sound!  

*(Optional)*  Modify `samplerbox.py`'s first lines if you want to change root directory for sample-sets, default soundcard, etc.


[How to use it](#howto)
----

See the [FAQ](http://www.samplerbox.org/faq) on www.samplerbox.org.


[ISO image](#isoimage)
----

The ready-to-use ISO images available on [www.samplerbox.org](http://www.samplerbox.org) are built with the help of a script that can be found in `isoimage/samplerbox_iso_maker.sh`.


[About](#about)
----

Author : Joseph Ernest (twitter: [@JosephErnest](http:/twitter.com/JosephErnest), mail: [contact@samplerbox.org](mailto:contact@samplerbox.org))


[License](#license)
----

[Creative Commons BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/)
