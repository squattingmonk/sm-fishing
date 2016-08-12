# Squatting Monk's Fishing System

## Introduction
This is a highly customizable and extensible fishing system for Neverwinter Nights. It aims to provide a framework for module builders to add the fishing system *they* want without having to script it all from scratch.

This system is currently in **alpha status**. While it is usable, it should be considered unstable and unsuitable for production use.

### Features
- **Script-driven**: All customization is done by editing the script `fish_c_config.nss`. No need to mess with item inventories or put a ton of variables on objects.
- **Documented**: The code is thoroughly documented to make it easy to use. I also plan to provide quite a few examples of some of the different extensions mentioned below.
- **Customizable fish**: Add as many or as few as you want. You can change how easy they are to catch and what bait and equipment they can be caught with.
- **Customizable environments**: Define your own environments (e.g., "freshwater", "lake", or "Murkwater Pond") and specify how common fish are in those environments.
- **Customizable equipment**: Want to have fishing poles of varying quality? Want to add fishing spears and nets? Piece of cake!
- **Inheritance**: fish found in more general environments can be found in more specific ones. A fish defined as living in "freshwater" environments will also live in "lake" and "river" environments without having to be added to both. Similarly, a fish that can be caught with "live" bait can be caught with "insect" or "worm" bait types.
- **Extensible**: There are hook-in functions to change the behavior of the system at all points without diving into the guts of the system. Using them, you could:
    - add flavor text
    - add a chance to fish up seaweed or an old boot
    - add a persistent fishing skill using your favored database system
    - change how likely a species of fish is to bite based on the time of day

### Non-Features
- Anything that needs to be included in a .hak file. There are no new models for fishing poles, bait, or fish. There are no new sound effects or animations. However, the system can make use of these assets through the config functions if you so choose.
- Blueprints. Aside from a few blueprints included for demonstration purposes, the creation of fishing poles, bait, and fish are up to the module builder. The documentation will (eventually) discuss in detail how to do this. I may eventually throw together some example packages for systems of varying complexity.

## Installation
### Dependencies
- `util_i_lists.nss` from [SM Utils](https://github.com/squattingmonk/sm-utils)

### Scripts
Import the following scripts into your module:
- `fish_c_config.nss`
- `fish_i_main.nss`
- `fish_t_equipment.nss`

### Blueprints
| Blueprint              | Required | Function |
| ---------              | -------- | -------- |
| `fish_fishingspot.utw` | yes      | Waypoint denoting fishing spots |
| `fish_t_pole.uti`      | no       | Demo fishing pole item |
| `fish_t_spear.uti`     | no       | Demo fishing spear item |
| `fish_trout.uti`       | no       | Demo fish item |
| `worm.uti`             | no       | Demo bait item| 

### Fishing Spots
Place fishing spot waypoints in the water wherever you want the PC to be able to fish. To define the type of environment the fishing spot represents, change the name of the waypoint to the name of the environment.

The distance the PC must be from the fishing spot is configurable in `fish_c_config.nss`. You may need multiple fishing spots to ensure full coverage of a given body of water.

## Configuration
All configuration is done through the `fish_c_config.nss` file. More in-depth documentation of the configuration file will come soon. For now, use the comments in the script.

### Notes
- Do *not* edit any files besides `fish_c_config.nss`. Any option that is meant to be altered is located there. Alterations to other files in the system are considered unsupported.
- Upon editing `fish_c_config.nss`, you *must* recompile `fish_t_equipment.nss` for the changes to be reflected in the game.

## Usage
Simply use some fishing equipment near a fishing spot.

## TODO
- improve online documentation
- create .erf for easy import
- add demo module with in-game explanations
- create presets for minimal, lite, and full configurations to demonstrate fish customization
- add instructions for all extensions suggested in the documentation
- test, test, test
