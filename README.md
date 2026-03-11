# DualScope
DualScope by NaviVani , edited for Bazzite-Deck by WhopperJr13

This is a simple script, originally by NaviVani, to enable local multiplayer in Steam games. Unlike other solutions, like PartyDeck, this script simply opens two entire Steam instances. The second instance requires a second account on your PC, second Steam account, and therefore a second license for the game. This also means that the games will be installed twice on your PC (maybe this can be improved). However, it enables the two Steam instances to not just play with each other locally, but also with other Steam accounts online, e.g. for a 4-player session of Peak but with two of the sessions locally on one PC. 

In this repository, I am sharing some additional scripts I made so that DualScope works a bit more seamlessly on Bazzite-Deck. We have two versions of DualScope, for if you want to split your display vertically or horizontally. Furthermore, we have introduced some simple wrapper scripts so that DualScope can be started/stopped directly from Gaming Mode, without having to manually go to desktop mode and use a keyboard/mouse. 

If anyone comes across this and needs help, we can work on sprucing up the documentation. In the meantime, here are the installation instructions: 
1) Run `setup.sh` to move the files to the appropriate places. 
2) In Settings -> Autostart -> Add New -> Application, add two autostart entries pointing to a) `dualscope_vertical_payload.sh` and b) `dualscope_payload.sh` 
3) Add `dualscope_vertical_trigger.sh` and `dualscope_trigger.sh` to Steam as non-Steam games. In Bazzite, you can do this by just right-clicking -> Add to Steam. 
4) You can then edit the name and artwork in Steam to make it pretty. Some artwork is provided in the "artwork" folder. If you have the SteamGridDB Decky Plugin, I've submitted these files to the database under "DualScope", although as of writing they are still waiting approval.
