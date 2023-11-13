# ExternalMonitorBrightness

This is a Plasmoid widget for KUbuntu (the KDE flavour of Ubuntu). It can control the brightness of an external monitor that understands DDC (Display Data Channel) commands.
The Plasmoid is written using KDE's Plasma Framework QML API.

It requires 'ddcutil' to be installed::

    sudo apt install ddcutil

TODO: It currently has a hard-coded value for the i2c bus id for my monitor. Will add a UI based selector for probing for attached monitors and saving this into a profile. 

### Demo 
(Links to YouTube)

[![IMAGE ALT TEXT](http://img.youtube.com/vi/2fzLgCb2rpU/0.jpg)](http://www.youtube.com/watch?v=2fzLgCb2rpU "ExternalMonitorBrightness")
