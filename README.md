<img width="920" height="430" alt="WideCapsuleVertical" src="https://github.com/user-attachments/assets/9903d9af-2cd6-42d8-b815-388c788382fa" />

# DualScope
DualScope by NaviVani, edited for Bazzite-Deck by WhopperJr13

This is a simple script, originally by NaviVani, to enable local multiplayer in Steam games. Unlike other solutions, like PartyDeck, this script simply opens two entire Steam instances. The second instance requires a second account on your PC, second Steam account, and therefore a second license for the game. This also means that the games will be installed twice on your PC (maybe this can be improved). However, it enables the two Steam instances to not just play with each other locally, but also with other Steam accounts online, e.g. for a 4-player session of Peak but with two of the sessions locally on one PC. 

In this repository, I am sharing some additional scripts I made so that DualScope works a bit more seamlessly on Bazzite-Deck. We have two versions of DualScope, for if you want to split your display vertically or horizontally. Furthermore, we have introduced some simple wrapper scripts so that DualScope can be started/stopped directly from Gaming Mode, without having to manually go to desktop mode and use a keyboard/mouse. 

# Installation
If anyone comes across this and needs help, we can work on sprucing up the documentation. In the meantime, here are the installation instructions I came up with retracing my steps.

0) If necessary, edit the script, e.g. in my case I am using an 8BitDo Ultimate 2C and an Xbox bluetooth controller connected to an 8BitDo USB Adapter 2. If you use other controllers, the names will need to be edited so the script can find them. NaviVani's original script had an interactive prompt in the terminal, but I wanted to make it automatic so I wouldn't need to use a keyboard/mouse. 

1) Download/clone the repository, then run `setup.sh` to automatically copy the files to the appropriate places:
   - `dualscope.sh` and `dualscope_vertical.sh` need to go into a root-owned persistent folder. Currently, I put them in `/usr/local/bin/dualscope`
   - The "trigger" and "paylad" files can go anywhere really; I put them in `~/Scripts`
   - I also added sudoer rules so that the DualScope scripts can run without having to enter a password. 
   - The `setup.sh` script will also try to make a second user account named `PlayerTwo` from which the second Steam instance will be called.
3) In Settings -> Autostart -> Add New -> Application, add two autostart entries pointing to a) `dualscope_vertical_payload.sh` and b) `dualscope_payload.sh` 
4) Add `dualscope_vertical_trigger.sh` and `dualscope_trigger.sh` to Steam as non-Steam games. In Bazzite, you can do this by just right-clicking -> Add to Steam. 
5) You can then edit the name and artwork in Steam to make it pretty. Some artwork is provided in the "artwork" folder. If you have the SteamGridDB Decky Plugin, I've submitted these files to the database under "DualScope", although as of writing they are still waiting approval.

I haven't tried a second time to set this up, so I may be missing some details. If so, just open an issue.
