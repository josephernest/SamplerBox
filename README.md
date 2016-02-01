SamplerBox
==========

An open-source audio sampler project based on RaspberryPi.

Website: www.samplerbox.org

[![](http://gget.it/flurexml/1.jpg)](https://www.youtube.com/watch?v=yz7GZ8YOjTw)

[Install](#install)
----

You need a RaspberryPi and a DAC (such as [this 6€ one](http://www.ebay.fr/itm/1Pc-PCM2704-5V-Mini-USB-Alimente-Sound-Carte-DAC-decodeur-Board-pr-ordinateur-PC-/231334667385?pt=LH_DefaultDomain_71&hash=item35dc9ee479) that provides really high-quality sound – please note that without any DAC, the RaspberryPi's built-in soundcard would produce bad sound quality and lag).

1. Install the required dependencies (Python-related packages and audio libraries):

  ~~~
  sudo apt-get update ; sudo apt-get -y install python-dev python-numpy cython python-smbus portaudio19-dev
  git clone https://github.com/superquadratic/rtmidi-python.git ; cd rtmidi-python ; sudo python setup.py install ; cd .. 
  git clone http://people.csail.mit.edu/hubert/git/pyaudio.git ; cd pyaudio ; sudo python setup.py install ; cd ..
  ~~~

2. Download SamplerBox and build it with: 

  ~~~
  git clone https://github.com/josephernest/SamplerBox.git ;
  cd SamplerBox ; make 
  ~~~

3. Run the soft with `python samplerbox.py`.

4. Play some notes on the connected MIDI keyboard, you'll hear some sound!  

*(Optional)*  Modify `samplerbox.py`'s first lines if you want to change root directory for sample-sets, default soundcard, etc.

<!--  *Note:* Don't install `pyaudio` with `apt-get install python-pyaudio` since this would install version 0.2.4, that wouldn't work for this project. Version 0.2.8 or higher is required. -->

[How to use it](#howto)
----

See the [FAQ](http://www.samplerbox.org/faq) on www.samplerbox.org.


[About](#about)
----

Author : Joseph Ernest (twitter: [@JosephErnest](http:/twitter.com/JosephErnest), mail: [contact@samplerbox.org](mailto:contact@samplerbox.org))


[License](#license)
----

[Creative Commons BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/)
