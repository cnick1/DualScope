#!/bin/bash
# This is a simple setup script to copy the dualscope files to the necessary locations so that they can be triggered from gaming mode without using a keyboard/mouse.

# Copy the actual dualscope scripts
sudo cp dualscope_vertical.sh /usr/local/bin/dualscope/dualscope_vertical.sh
sudo cp dualscope.sh /usr/local/bin/dualscope/dualscope.sh

# Copy the trigger and payload scripts:
# - The trigger scripts are what can be added to Steam to launch from gamemode. Since gamemode runs in a gamescope instance, the dualscope script and switching to desktop would terminate itself. So, instead, we use an autostart at login script to launch dualscope. To avoid launching every time we go to desktop, we look for a tmp file as the indication that we actually want to start dualscope. The trigger file makes the tmp file.
# - The payload scripts are what we add to the autostart folder. The payload script looks for the tmp file; if it finds it, it deletes it and proceeds to run dualscope. If it doesn't find it, it does nothing and exits so that the desktop is shown like normal.
sudo cp dualscope_vertical_trigger.sh ~/Scripts/dualscope_vertical_trigger.sh
sudo cp dualscope_trigger.sh ~/Scripts/dualscope_trigger.sh
sudo cp dualscope_vertical_payload.sh ~/Scripts/dualscope_vertical_payload.sh
sudo cp dualscope_payload.sh ~/Scripts/dualscope_payload.sh

# Make everything executable
sudo chmod +x /usr/local/bin/dualscope/dualscope_vertical.sh
sudo chmod +x /usr/local/bin/dualscope/dualscope.sh

sudo chmod +x ~/Scripts/dualscope_vertical_trigger.sh
sudo chmod +x ~/Scripts/dualscope_trigger.sh
sudo chmod +x ~/Scripts/dualscope_vertical_payload.sh
sudo chmod +x ~/Scripts/dualscope_payload.sh

# Copy over the autostart shortcuts. These run the payload scripts on login.
# - it looks like these require the use of absolute paths, which requires the individual's username. So instead, just manually make the autostart entries yourself. They just need to point to the payload scripts.
# sudo cp DualScopeVertical.desktop ~/.config/autostart/DualScopeVertical.desktop
# sudo cp DualScope.desktop ~/.config/autostart/DualScope.desktop
