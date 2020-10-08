# RadialArmMaze
Radial 8 arm maze GUI code

This codebase was used to interface with MazeEngineer's Radial 8 Arm Maze hardware, and requires TTL inputs from the device. 

We utilized this apparatus to collect behavioral experimental data.


### Usage



Turn on the machine then run mainRAM.m to start the behavioral task.

TTL events are automatically displayed on the left hand side. 


### Buttons and interface

Timers for the entire session and per trial are displayed above. Position is estimated using photobeam events.

1) START to initialize the machine and open all the doors
2) OPEN to begin the next trial
3) CLOSE to end the current trial
4) END to finish the session and save the data

Users can add notes using the writer at the bottom of the GUI. 
Doors and reward ports can also be individually tested using the buttons on the right


![RAMGUI](https://github.com/dsiu1/RadialArmMaze/blob/master/RAMGUI.PNG)
