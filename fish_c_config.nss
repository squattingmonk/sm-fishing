/*
Filename:        fish_c_main.nss
System:          SM's Fishing System (configuration script)
Author:          Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
Date Created:    Aug. 2, 2015
Summary:
Fishing System configuration settings. This script is freely editable by the mod
builder. All below settings may be overridden, but do not alter the names of the
constants or functions.

This script is consumed by fish_t_equipment as an include directive.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "fish_i_main"

// -----------------------------------------------------------------------------
//                                 Extensions
// -----------------------------------------------------------------------------

// If you need to add any additional includes, constants, or functions to extend
// the config functions below, you may add them here.


// -----------------------------------------------------------------------------
//                              Config Functions
// -----------------------------------------------------------------------------

// The following are configurable functions that hook into the main fishing
// routine when a fishing equipment item is used. You may change anything inside
// of the functions, but do not change the function names or parameters.

// This is a configurable function you can use to alter the fish, environments,
// equipment, and tackle used in your module. All of the following code will run
// the first time a fishing item is used or acquired in your module.
void OnFishingSetup()
{
    // ----- System Settings ---------------------------------------------------

    SetFishingDebugMode(TRUE);

    // ----- Equipment Settings ------------------------------------------------

    SetFishingDistance(3.0);
    SetFishingDistance(10.0, "pole");

    SetIsFishingTackle("worm", "bait");
    SetIsFishingTackle("hook_large", "hook");
    SetIsFishingTackle("bait, float, hook, line, sinker");

    SetFishingTackleSlots("pole", "hook", "bait, float, line, sinker");


    // ----- Fish Definitions --------------------------------------------------

    AddFish(20, "trout, bass");


    // ----- Environment Definitions -------------------------------------------

    BlacklistFishEnvironment("lake", "trout");

    SetFishEnvironmentModifier(10, "pond, river", "trout");
    SetFishEnvironmentModifier(10, "lake", "bass");


    // ----- Equipment Definitions ---------------------------------------------

    BlacklistFishEquipment("spear", "bass");


    // ----- Tackle Definitions ------------------------------------------------

    WhitelistFishTackle("hook", "trout");
    WhitelistFishTackleSlot("bait", "bass");

    SetFishTackleModifier(-10, "hook_large", "bass");
    SetFishTackleSlotModifier(10, "bait", "");


    // ----- Event Messages-----------------------------------------------------

    AddFishMessage(FISH_EVENT_NO_SPOT,    "", "This doesn't look like a good place to fish.");
    AddFishMessage(FISH_EVENT_BAD_TARGET, "", "You can't use this item on that target.");
    AddFishMessage(FISH_EVENT_USE_TACKLE, "", "You apply the tackle to your equipment.");

    AddFishMessage(FISH_EVENT_NO_TACKLE,  "pole", "You need a hook to fish with this equipment.");

    AddFishMessage(FISH_EVENT_START,     "pole", "You cast your line. Now to wait...");
    AddFishMessage(FISH_EVENT_NIBBLE,    "pole", "You feel a tug on your line!");
    AddFishMessage(FISH_EVENT_NIBBLE,    "pole", "Something took your bait!");
    AddFishMessage(FISH_EVENT_CATCH,     "pole", "After a brief struggle, you reel in the fish.");
    AddFishMessage(FISH_EVENT_NO_CATCH,  "pole", "The line goes slack. It look like he got away.");

    AddFishMessage(FISH_EVENT_START,  "spear", "You ready your spear, eyes intent on the water...");
    AddFishMessage(FISH_EVENT_NIBBLE, "spear", "There's a fish!");
    AddFishMessage(FISH_EVENT_NIBBLE, "spear", "You spy a fish!");

    AddFishMessage(FISH_EVENT_NO_CATCH,  "pole, spear", "Dammit! He got away.");
    AddFishMessage(FISH_EVENT_NO_NIBBLE, "pole, spear", "You failed to catch anything. Better luck next time!");
}

// This is a configurable function that runs when the PC uses a fishing tackle
// item and has fishing equipment equipped. Returns whether the tackle should be
// added to the equipped item. Example uses include removing the tackle from the
// player's inventory when used, giving back tackle already applied to the same
// slot, or requiring a hook type of tackle to be applied before allowing a bait
// type of tackle.
//
// You can add tackle to a fish's list using AddFishTackle() in the
// OnFishingSetup() config function below. This function takes a comma-separated
// list of fish and and tackle, making it easy to add many tackle types to many
// fish. The function also allows you to add a modifier to the chances a fish
// will bite when the PC is using that tackle. This allows fish to prefer
// different tackle.
//
// Parameters:
// - oEquipment: the PC's currently equipped fishing equipment
// - oTackle: the tackle item being used
// - sSlot: the slot the tackle is being applied to
// Returns: whether to apply the tackle to the equipment.
int OnFishingTackleUsed(object oEquipment, object oTackle, string sSlot)
{
    // Remove current tackle of the same type and give it back to the PC.
    RemoveFishingTackle(sSlot, TRUE, oEquipment);

    // Tackle should be single use.
    DestroyObject(oTackle);
    return TRUE;
}

// This is a configurable function that runs when the PC uses fishing equipment.
// Returns whether the PC is able to fish. Example uses include setting a max
// distance to the fishing spot based on his equipment, providing flavor text
// about the cast, adding additional restrictions for fishing, or setting a time
// limit between fish bites.
// - OBJECT_SELF: the PC fishing
int OnFishingStart()
{
    return TRUE;
}

// This is a configurable function that allows you to prevent a fish from
// performing a nibble check. Use this when there are instances that will always
// bar a fish from biting. Example uses include making some fish only active at
// night, during rain, or with certain tackle combinations. For simple
// environment, equipment, or tackle restrictions, consider using the
// WhitelistFish*() and BlacklistFish*() functions in OnFishingSetup() instead.
// - OBJECT_SELF: the PC attempting to catch the fish.
// - sFish: the resref of the fish whose bite we're testing.
// Returns: whether or not the fish may attempt to nibble (TRUE/FALSE).
int OnFishRequirements(string sFish)
{
    return TRUE;
}

// This is a configurable function that allows you to modify the chances a type
// of fish will bite. Example uses include making fish more or less likely to
// bite at different times of day or month, modifying chances based on the
// weather, or keeping a type of fish from biting if it's been "fished out" of
// the spot.
// - OBJECT_SELF: the PC attempting to catch the fish.
// - sFish: the resref of the fish whose chances to bite we're testing.
// Returns: an amount to add to the chance the fish will bite.
int OnFishNibble(string sFish)
{
    return 0;
}

// This is a configurable function to handle what happens when the PC fails to
// get a fish to nibble on the line. Example uses include notifying the PC of
// his failure, adding a chance of losing his bait, or having him catch seaweed
// or an old boot instead.
// - OBJECT_SELF: the PC who failed to catch a fish.
// Returns: whether to display the failure animation and message.
int OnFishNibbleFail()
{
    return TRUE;
}

// This is a configurable function to handle what happens when a PC gets a fish
// on the line. Returns whether the PC is successful at catching the fish.
// Example uses include giving flavor text about the fish's struggle, requiring
// an ability check to catch it, or setting the fishing spot as unavailable for
// a time.
// - OBJECT_SELF: the PC fishing.
// - sFish: the resref of the fish the PC has on the line.
int OnFishNibbleSuccess(string sFish)
{
    return TRUE;
}

// This is a configurable function to intercept the actual creation of the fish.
// Returns whether the system should create the fish. Example uses include
// removing the PC's bait, copying a fish from a container rather than creating
// one from a blueprint (to save on palette items), increasing a persistently
// stored fishing skill, or even just giving the player some XP.
int OnFishCatch(string sFish)
{
    // Add a "fish_" as a prefix to the resref.
    ActionCreateFish(sFish, "fish_");
    return FALSE;
}

// This is a configurable function to handle the animations for different stages
// of the fishing. Returns whether or not to play the default animation.
// - nEvent: the fishing event which is currently playing
//   - FISH_EVENT_START: plays when fishing begins (after OnFishingStart())
//   - FISH_EVENT_NIBBLE: plays when a fish has passed the nibble check
//   - FISH_EVENT_CATCH: plays when a PC successfully catches a fish
//   - FISH_EVENT_NO_CATCH: plays when a fish nibbled but was not caught
//   - FISH_EVENT_NO_NIBBLE: plays when no fish nibbled at all
int PlayFishingAnimation(int nEvent)
{
    return TRUE;
}
