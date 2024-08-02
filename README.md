# Bloons Tower Defense 6: Farming Script

**SEE INFORMATION REGARDING UPDATE 44 [BELOW](#mermonkey)**

## What Is It?

Repeatedly plays "Deflation" mode on the map "Infernal." Each game takes just under 6 minutes (10-11 games/hr). 

This is *not* a mod, and does not connect with the game in any way; it controls your keyboard and mouse to play the game like a normal player would.

## Limitations

- Currently cannot train water monkeys
- Unpurchased monkey upgrade paths will stall script
- Updated as of BTD6 update 43; new maps since then may break the script and new monkeys since then will be missing

### Performance Numbers

- Earns account levels/monkey knowledge (~600,000 XP/hr)
- Earns tower XP (varying rates)
- Earns monkey money (600-700 money/hr)

## Requirements

### Modes/Maps

- Expert-difficulity map "Infernal" unlocked
- "Infernal: Easy" beaten
- "Infernal: Primary only" beaten
    - [Tutorial](https://www.youtube.com/watch?v=Wtgh8M0MDN4)
    
### Monkeys

#### "Heli" Strategy

Original, more reliable
- 320 helicopter x2
- 204 sniper

#### "Sniper" Strategy

Newer, may lose some lives but has more leftover cash for XP monkey
- 202 village
- 024 sniper
- 301 alchemist

## How to use

### Notes/Troubleshooting

- Make sure you have the required towers unlocked/upgrades purchased before starting
- Designed for 16:9 resolution, if mouse clicks are missing, try changing your resolution
- Will work if game is fullscreen, but menu is nicer if it isn't in fullscreen
- Must start script from main menu and make sure the last time you viewed the maps it was not left on the page where Infernal is currently visible

### Mermonkey

- Requires 3 million pops to unlock the base tower
    - Total pop count of **all** tower types, **not** the damage
    - Co-op will give **all** players the total of **all players' towers combined**
    - Pops only counted on medium/hard difficuly and freeplay **is** allowed
    - Easy/fast way to complete is by doing the MOAB Madness Quest about 3 times, takes less than 15 minutes
        - [Tutorial](https://youtu.be/WVw36Pxh0GI?feature=shared)
- Mermonkey hotkey is unset by default, **set it to the previously unused "o" key for the script to work**
    - Default being unset is likely due to the other default hotkey assignments not leaving space for Mermonkey to be assigned beside the other magic monkeys
- Due to issue https://github.com/gavboi/btd6-farming/issues/1, the script will need to be babysat while the tower is unlocking the initial upgrades

### Full Controls

- `Ctrl+M` -> Open menu
    - Select monkey to level up
    - Select strategy to use
    - View stats
    - Exit script
- `Ctrl+S` -> Start loop
- `Ctrl+X` -> Stop loop, exit if already stopped
