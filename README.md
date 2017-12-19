# Squatting Monk's Fishing System

## Introduction
This is a highly customizable and extensible fishing system for Neverwinter Nights. It aims to provide a framework for module builders to add the fishing system *they* want without having to script it all from scratch.

This system is currently in **alpha status**. While it is usable, it should be considered unstable and unsuitable for production use.

### Features
- **Script-driven**: All customization is done by editing the script `fish_c_config.nss`. No need to mess with item inventories or put a ton of variables on objects.
- **Documented**: The code is thoroughly documented to make it easy to use. I also plan to provide quite a few examples of some of the different extensions mentioned below.
- **Customizable fish**: Add as many or as few as you want. You can change how easy they are to catch and what tackle and equipment they can be caught with.
- **Customizable environments**: Define your own environments (e.g., "freshwater", "lake", or "Murkwater Pond") and specify how common fish are in those environments.
- **Customizable equipment**: Add fishing poles of varying quality, fishing spears, or nets. You can also create your own tackle and bait types and easily specify which equipment can use which tackle.
- **Extensible**: There are hook-in functions to change the behavior of the system at all points without diving into the guts of the system. Using them, you could:
    - add flavor text
    - add a chance to fish up seaweed or an old boot
    - add a persistent fishing skill using your favored database system
    - change how likely a species of fish is to bite based on the time of day
    - and much more

### Non-Features
- Anything that needs to be included in a .hak file. There are no new models for fishing poles, bait, or fish. There are no new sound effects or animations. However, the system can make use of these assets through the config functions if you so choose.
- Blueprints. While the beta will include example configurations along with a demo module showing it in practice, in the base system the creation of fishing poles, tackle, and fish are up to the module builder. The documentation will (eventually) discuss in detail how to do this.

## Dependencies
- Neverwinter Nights 1.69 or higher
- `util_i_lists.nss` from [sm-utils](https://github.com/squattingmonk/sm-utils)

## Installation

1. Ensure that tag-based scripting is enabled in your module.
2. Import `sm_fishing.erf` into your module. The package contains the following resources:

| Resource               | Function                                       |
| ---------              | ---------                                      |
| `fish_c_config.nss`    | Configuration script                           |
| `fish_i_main.nss`      | Main include script                            |
| `fish_t_equipment.nss` | Tag-based script for fishing equipment         |

## Usage
Simply use some fishing equipment near a fishing spot.

### Fishing Equipment
Fishing equipment is any item that can be used to fish. An example of fishing equipment is a fishing pole. Any base item type can be used as fishing equipment, provided:

1. It has a Cast Spell: OnActivate item property. Activating the item will cause it to be used.
2. It has a tag of the format `fish_t_equipment_*` where * is the type of equipment it is. Alternatively, the tag may be set to `fish_t_equipment` and the resref will be used as the equipment type.

There is no limit to the number of types of equipment you can make.

### Fishing Tackle
Tackle is a special type of fishing equipment that is applied to fishing equipment but cannot be used to fish on its own. Examples of tackle include bait, hooks, fishing line, sinks, or floats. Any fishing equipment can be used as tackle by defining it as tackle in `fish_c_config.nss`. Like all fishing equipment, tackle must have the proper tag and itemproperty to work.

Tackle fits into a defined slot on equipment. This allows you to specify which equipment can use which tackle. These slots may be required (i.e., the PC cannot fish with the equipment unless he has the necessary tackle slot filled) or optional.

Only one type of tackle may occupy a slot at any time. The PC can see which tackle is in use on his equipment by examining it: the item's description will be updated whenever tackle is added or removed.

Tackle is defined in `fish_c_config.nss`. Examples will be provided in further documentation.

### Fishing Spots
Fishing spots are waypoints or triggers with the tag `fish_fishingspot`.

Place fishing spot waypoints in the water wherever you want the PC to be able to fish. The distance the PC must be from a fishing spot waypoint is configurable in `fish_c_config.nss`. You may need multiple fishing spots to ensure full coverage of a given body of water.

Alternatively, you may paint a fishing spot trigger around the fishable area. Any PC standing inside the trigger will be able to fish there. While a fishing spot trigger does not need an OnEnter script to function, you may make use of one to tell the PC this is a good place to fish.

Fishing spots represent certain environments, and these environments can be customized to contain different fish. To define the type of environment the fishing spot represents, change the name of the waypoint or trigger to the name of the environment. Example configuration will be provided in later documentation.

### Configuration
All configuration is done through the `fish_c_config.nss` file. More in-depth documentation of the configuration file will come soon. For now, use the comments in the script.

#### Note
- Do *not* edit any files besides `fish_c_config.nss`. Any option that is meant to be altered is located there. Alterations to other files in the system are considered unsupported.
- Upon editing `fish_c_config.nss`, you *must* recompile `fish_t_equipment.nss` for the changes to be reflected in the game.

## TODO
- improve online documentation
- update demo module with in-game explanations
- create presets for minimal, lite, and full configurations to demonstrate fish customization
- add instructions for all extensions suggested in the documentation
- test, test, test
