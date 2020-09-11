#!/bin/bash
cd /opt/
git clone https://github.com/devegoo/SamplerBox.git
cd SamplerBox
chmod +x install_requeriments
./install_requeriments
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
#services / control
cd tools
cp samplerbox.service /etc/systemd/system/samplerbox.service
cp start_samplerbox /usr/bin/
cp stop_samplerbox /usr/bin/
# sample renamer
cp nametonote /usr/bin/
chmod +x /usr/bin/start_samplerbox
chmod +x /usr/bin/stop_samplerbox
chmod +x /usr/bin/nametonote

