# SamplerBox

*Update: [Remove drums from song](https://www.yellownoiseaudio.com) with the VST DrumExtract!*

&nbsp;

SamplerBox is an **open-source DIY audio sampler project** based on RaspberryPi.

Website: [www.samplerbox.org](https://www.samplerbox.org)

[![](https://gget.it/flurexml/1.jpg)](https://www.youtube.com/watch?v=yz7GZ8YOjTw)

# Install

SamplerBox works with the RaspberryPi's built-in soundcard, but it is recommended to use a USB DAC (PCM2704 USB DAC for less than 10€ on eBay is fine) for better sound quality.

0. Start with a standard RaspiOS intsall. The following steps have been tested with [2021-05-07-raspios-buster-armhf-lite.zip](https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip).

1. Install the required dependencies (Python-related packages and audio libraries - the current version requires at least Python 3.7):

    ~~~
    sudo apt update
    sudo apt -y install git python3-pip python3-smbus python3-numpy libportaudio2 
    sudo apt -y install raspberrypi-kernel  # quite long to install, do it only if necessary, it solves a "no sound before 25 second on boot" problem
    sudo pip3 install cython rtmidi-python cffi sounddevice pyserial
    ~~~
    
2. Download SamplerBox and build it with:

    ~~~
    git clone https://github.com/josephernest/SamplerBox.git
    cd SamplerBox
    sudo python3 setup.py build_ext --inplace
    ~~~

3. Reboot the Pi, and run the soft with: 
    
    ~~~
    sudo python3 samplerbox.py
    ~~~

    Play some notes on the connected MIDI keyboard, you'll hear some sound!

4. *(Optional)*  Modify `config.py` if you want to change root directory for sample-sets, default soundcard, etc.


# How to use it

See the [FAQ](https://www.samplerbox.org/faq) on https://www.samplerbox.org.

# Notes

A few remarks:

* the current version also works on Windows if all the required modules are installed
* MIDI via GPIO/serial should be re-tested with the current version, see https://github.com/josephernest/SamplerBox/issues/49.

# ISO image

The ready-to-use ISO images available on [www.samplerbox.org](https://www.samplerbox.org) are built with the help of a script that can be found in `isoimage/maker.sh`.

# About

Author : Joseph Ernest (twitter: [@JosephErnest](https:/twitter.com/JosephErnest), mail: [contact@samplerbox.org](mailto:contact@samplerbox.org))

# Sponsors and consulting

I am available for Python, Data science, ML, Automation **consulting**. Please contact me on https://afewthingz.com for freelancing requests.

Do you want to support the development of my open-source projects? Please contact me!

I am currently sponsored by [CodeSigningStore.com](https://codesigningstore.com). Thank you to them for providing a DigiCert Code Signing Certificate and supporting open source software.

# License

[Creative Commons BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)
