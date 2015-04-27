# Admin-Tools (former Zcript)

Rising World server administration tool set.


## Introduction

This script is an update of h0tw1r3 h0tsript. It gives server's admin more tools to work around the server.


## Installation

So far, this module isn't using any depencies, but check this page often as we're planning to use some soon !

### Using Git

Go to the `scripts` folder of your Rising World installation and type

```
git clone --recursive https://github.com/RisingWorld/admin-tools.git
```

### Manually

Download the Zip file for [this](https://github.com/RisingWorld/admin-tools/archive/master.zip) repository and extract it to your Rising World's `scripts/world-edit` folder.

Your final script folder should look somewhat like this

```
./risingworld/scripts/admin-tools
   ./script.lua
   ./definition.xml
   ./support.lua
   ./zcript.lua
```




## Usage

In-game, in chat, type `/<command>` where `<command>` is one of the following :

### Commands


*`/ban <player> <duration in minutes, -1 is permenant> <reason>` 
  Self explanatory. Is an improvement of the in game function, allowing you you to ban disconnected players !

*`/unban <player>` 
  Self explanatory.

*`/setWelcome <message>`   
  Allow you to set-up a welcome message that will be displayed on the server when a player is connecting.

*`/setMotd <message>`  
  Allow you to set-up a Message Of The Day that will be displayed evry hour.

*`/yell OR /y <message>`  
  Allow an admin to say something that will be displayed on all connected player screen.

*`/kill2  <player name OR player ID>`   
  Allow an admin to kill a player with his name or his ID. The name or the ID is the one displayed when showing the score board.

*`/tp <player ID or player name>`   
  Allow an admin to teleport himself on the location of the player associated to the ID or name. The name or ID is the one displayed when showing the score board.
  /!\ The admin won't be teleported exactly on the same position that the player, but with an offset of (1.1.1) ! You might fall of the map !

*`/tp2 <palyer ID or player name>`   
  Allow an admin to teleport a player on his location location. The name or the ID is the one displayed when showing the score board.
 
*`/last` 
  This command require no parameters. This will return the name of the last logged in player.

*`/whisper <player>` OR `/w <player> <message>` 
  Thoose commands allow anyone to whisper to someone else.

*`/pos` 
  This command return the position along 3 axis of the player : X,Y,Z

*`/heal <player>`
  



## Contributors

* Zabka (Vianey Benjamin)
* username (Official RW Forum user)
* yahgiggle 



## License

Copyright (c) 2015 Rising World Contributors

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
