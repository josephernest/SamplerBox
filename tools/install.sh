#!/bin/bash
#services / control
cp samplerbox.service /etc/systemd/system/samplerbox.service
ln -s start_samplerbox /usr/bin/
ln -s stop_samplerbox /usr/bin/

# sample renamer
ln -s nametonote /usr/bin/

