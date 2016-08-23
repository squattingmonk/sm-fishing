/*
Filename:        fish_t_equipment.nss
System:          SM's Fishing System (tag-based script)
Author:          Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
Date Created:    Aug. 9, 2015
Summary:
This script handles tag-based events for fishing equipment. Acquiring fishing
equipment will set up the fishing system automagically. You should not edit this
file. All configurable settings are found in fish_c_config.

If the item is bait or tackle, it will be applied to any fishing equipment the
player has his hand. Otherwise, it will search for the nearest fishing spot. If
one is found within range, this will begin the fishing sequence.

You can create your own types of fishing equipment: simply give your item a
"Cast Spell: OnActivate (Self Only)" item property with unlimited uses and set
its tag to "fish_t_equipment_X", where X is the type of equipment your item is.
This will be the value you should use to refer to your equipment type in the
settings and config functions in fish_c_config.

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
    int nEvent = GetUserDefinedItemEventNumber();
    int bActivate = (nEvent == X2_ITEM_EVENT_ACTIVATE);
    int bAcquired = (nEvent == X2_ITEM_EVENT_ACQUIRE);

    if (!bActivate && !bAcquired)
        return;

    object oPC   = (bActivate ? GetItemActivator() : GetModuleItemAcquiredBy());
    object oItem = (bActivate ? GetItemActivated() : GetModuleItemAcquired());

    // Make sure the fishing system is set up.
    InitializeFishingSystem(oPC, oItem, FISH_DEBUG_MODE, FISH_BAIT_ITEMS, FISH_TACKLE_ITEMS);

    // Only run the rest OnActivate
    if (!bActivate)
        return;

    // If this is a bait item, let the system handle it and abort.
    if (HandleFishingBait(FISH_TEXT_USE_BAIT, FISH_TEXT_NO_EQUIPMENT))
        return;

    // If this is a tackle item, let the system handle it and abort.
    if (HandleFishingTackle(FISH_TEXT_USE_TACKLE, FISH_TEXT_NO_EQUIPMENT))
        return;

    // If there is no fishing spot nearby, abort.
    if (!VerifyFishingSpot(FISH_MAX_DISTANCE))
    {
        FloatingTextStringOnCreature(FISH_TEXT_NO_SPOT, oPC, FALSE);
        return;
    }

    //  We passed all our checks. Now we fish!
    AssignCommand(oPC, ActionFish(FISH_ITEM_PREFIX));
}
