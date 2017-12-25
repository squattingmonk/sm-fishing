# Squatting Monk's Fishing System
## Minimal Preset

This is a simple preset that shows a bare minimum configuration. This preset contains:

- One fish type: Fish. This fish is created automatically by the system because we do not define one in `fish_c_config.nss`. It uses the default NWN fish blueprint.
- One environment: Fishing Spot. This environment is the result of the default name found on a fishing spot waypoint.
- One tackle type: Bait. It is not required, but gives a bonus when fishing.

The demo module contains a helpful NPC that explains the usage of the system and sells fishing equipment.

## Installation
1. Ensure that tag-based scripting is enabled in your module.
2. Import `sm_fishing.erf` into your module.
3. Import `sm_fishing_min.erf` into your module, overwriting as necessary. The file contains the following resources:

| Resource               | Function                        |
| --------               | --------                        |
| `fish_c_config.nss`    | Configuration script            |
| `fish_t_bait.uti`      | bait item blueprint             |
| `fish_t_pole.uti`      | Fishing pole item blueprint     |
| `fish_fishingspot.utt` | Fishing spot trigger blueprint  |
| `fish_fishingspot.utw` | Fishing spot waypoint blueprint |


## Usage
Simply use a fishing pole near a fishing spot. Use bait when you have a fishing pole equipped to apply it to your pole. This will give you a bonus to catching a fish.
