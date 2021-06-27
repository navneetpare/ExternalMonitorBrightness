This is a Plasmoid widget for KUbuntu (the KDE flavour of Ubuntu). It can control the brightness of an external monitor that understands DDC (Display Data Channel) commands.

The Plasmoid is written using KDE's Plasma Framework QML API.

It requires 'ddcutil' to be installed::

    sudo apt install ddcutil



TODO: It currently has a hard-coded value for the i2c bus id for my monitor. Will add a UI based selector for probing for attached monitors and saving this into a profile. 
