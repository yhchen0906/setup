#! /bin/sh
sudo sed -E 's/^(enabled)=.*/\1=0/' -i /etc/default/apport
