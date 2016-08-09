/*
Filename:        fish_t_equipment.nss
System:          SM's Fishing System (library script)
Author:          Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
Date Created:    Aug. 9, 2015
Summary:
This script handles the OnActivate event for all fishing equipment. Activating
the item will set up the fishing system automagically. You should not edit this
file. All configurable settings are found in fish_c_config.

If the item is bait, it will apply the bait to any baitable item the player has
in his hand. Otherwise, it will search for the nearest fishing spot. If one is
found within range, this will begin the fishing sequence.

You can create your own types of fishing equipment: simply give your item a
"Cast Spell: OnActivate (Self Only)" item property with unlimited uses and set
its tag to "fish_t_equipment_X", where X is the type of equipment your item is.
This will be the value you should use to refer to your equipment type in the
settings and config functions in fish_c_config.

You can create your own types of bait, too: simply give your item a "Cast Spell:
OnActivate (Self Only)" item property with a single use and set its tag to
"fish_t_equipment_bait_X", where X is the type of bait your item is. This will
be the value you should use to refer to your bait type in the settings and
config functions in fish_c_config.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "x2_inc_switches"
#include "fish_c_config"

void main()
{
    // Only run OnActivate
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

    object oPC   = GetItemActivator();
    object oItem = GetItemActivated();

    // Make sure the fishing system is set up.
    if (InitializeFishingSystem(oPC, oItem, FISH_DEBUG_MODE))
    {
        // We're running for the first time, so let's apply our bait settings.
        SetFishInt(FISH_BAIT, FISH_BAIT_IS_REQUIRED, FISH_BAIT_REQUIRED);
        SetFishInt(FISH_BAIT, FISH_BAIT_IS_OPTIONAL, FISH_BAIT_OPTIONAL);
        SetFishInt(FISH_BAIT, FISH_BAIT_IS_IGNORED,  FISH_BAIT_IGNORED);
        SetFishInt(FISH_BAIT, FISH_BAIT_DEFAULT);
    }

    // If this is a bait item, let the system handle it and abort.
    if (HandleFishingBait(FISH_TEXT_USE_BAIT, FISH_TEXT_NO_EQUIPMENT))
        return;

    // If there is no fishing spot nearby, abort.
    // TODO: add ability to use a trigger rather than a waypoint
    if (!VerifyFishingSpot(FISH_MAX_DISTANCE))
    {
        FloatingTextStringOnCreature(FISH_TEXT_NO_SPOT, oPC, FALSE);
        return;
    }

    // If our fishing item requires bait and we have none, abort.
    if (!VerifyFishingBait())
    {
        FloatingTextStringOnCreature(FISH_TEXT_NO_BAIT, oPC, FALSE);
        return;
    }

    //  We passed all our checks. Now we fish!
    AssignCommand(oPC, ActionFish(FISH_ITEM_PREFIX));
}
