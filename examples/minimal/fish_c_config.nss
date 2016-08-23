/*
Filename:        fish_c_main.nss (minimal preset)
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
//                                  Constants
// -----------------------------------------------------------------------------

// If this is true, fishing will generate debug calls. This may be useful for
// tracking down errors in any of the config functions.
const int FISH_DEBUG_MODE = FALSE;

// This is the maximum distance, in meters, that a PC may be from a waypoint
// fishing spot to fish using any equipment. If this value is 0.0 or less, the
// PC will be able to fish in any area with a waypoint fishing spot. You may
// further refine this distance for various equipment types in the
// OnFishingStart() config functions below.
// Note: the PC will always be able to fish in a trigger fishing spot if he is
// inside of it.
const float FISH_MAX_DISTANCE = 10.0f;

// This prefix is added to any fish name to form the resref for that fish. This
// will allow you to follow a good resref naming scheme while still keeping the
// config functions below readable.
const string FISH_ITEM_PREFIX = "";

// ----- Bait and Tackle Lists -------------------------------------------------

// The following are lists of bait and tackle equipment types. These items
// cannot be used to fish; they can only be applied to fishing equipment items.
// Any fishing equipment that is not in these lists can be used to fish.
//
// You can create your own types of equipment:
// 1. Give your item a "Cast Spell: OnActivate (Self Only)" item property with
//    unlimited uses.
// 2. Set its tag to "fish_t_equipment_*", where * is the type of equipment your
//    item is. Alternatively, set the tag to "fish_t_equipment" and use the
//    resref as the eqipment type. This will be the value you should use to
//    refer to your equipment type in these constants and in the config
//    functions below.

// This is a comma-separated list of equipment to be treated as bait when used.
const string FISH_BAIT_ITEMS = "bait";

// This is a comma-separated list of equipment to be treated as tackle when used.
const string FISH_TACKLE_ITEMS = "";

// ----- Text Strings ----------------------------------------------------------

// This text strings that may be displayed to the PC by the system functions. If
// you wish to alter or translate these, you may do so here.
const string FISH_TEXT_USE_BAIT     = "You apply the bait to your equipment.";
const string FISH_TEXT_USE_TACKLE   = "You apply the tackle to your equipment.";
const string FISH_TEXT_NO_EQUIPMENT = "You can't use that with your currently equipped item!";
const string FISH_TEXT_NO_SPOT      = "This doesn't look like a good place to fish.";


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
// of the functions, but do not change the function names.

// This is a configurable function you can use to alter the fish, environments,
// baits, and tackle used in your module. All of the following code will run the
// first time a fishing item is used in your module.
void OnFishingSetup()
{
    // ----- Environment Definitions ------------------------------------------

    SetFishEnvironmentModifier(20, "Fishing Spot", "fish");

    // ----- Bait Definitions -------------------------------------------------

    SetFishBaitModifier(30, "bait", "fish");

    // ----- Event Messages-----------------------------------------------------
    AddFishMessage(FISH_EVENT_START,     "pole", "You cast your line. Now to wait...");
    AddFishMessage(FISH_EVENT_NIBBLE,    "pole", "You feel a tug on your line!");
    AddFishMessage(FISH_EVENT_NIBBLE,    "pole", "Something took your bait!");
    AddFishMessage(FISH_EVENT_NO_NIBBLE, "pole", "You failed to catch anything. Better luck next time!");
    AddFishMessage(FISH_EVENT_NO_CATCH,  "pole", "The line goes slack. It look like he got away.");
    AddFishMessage(FISH_EVENT_NO_CATCH,  "pole", "Dammit! He got away.");
    AddFishMessage(FISH_EVENT_CATCH,     "pole", "After a brief struggle, you reel in the fish.");
}

// This is a configurable function that runs when the PC uses a fishing bait
// item and has fishing equipment equipped. Returns whether the bait should be
// added to the equipped item. Example uses include limiting certain types of
// bait to certain types of equipment, allowing bait to be used only if the
// appropriate tackle has been applied, or removing the bait from the player's
// inventory when used.
//
// You can add baits to a fish's list using AddFishBaits() in the
// OnFishingSetup() config function below. This function takes a comma-separated
// list of fish and and bait, making it easy to add many baits to many fish. The
// function also allows you to add a modifier to the chances a fish will bite
// when the PC is using that bait. This allows fish to prefer different baits.
//
// Parameters:
// - oEquipment: the PC's currently equipped fishing equipment
// - oBait: the bait item being used
// Returns: whether to apply the bait to the equipment.
int OnFishingBaitUsed(object oEquipment, object oBait)
{
    // Remove any current bait and give it back to the PC.
    RemoveFishingBait(TRUE, oEquipment);

    // Bait should be single use.
    DestroyObject(oBait);
    return TRUE;
}

// This is a configurable function that runs when the PC uses a fishing tackle
// item and has fishing equipment equipped. Returns whether the tackle should be
// added to the equipped item. Example uses include limiting certain types of
// tackle to certain types of equipment, preventing multiple types of similar
// tackle from being added, and removing the tackle from the player's inventory
// when used.
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
// Returns: whether to apply the tackle to the equipment.
int OnFishingTackleUsed(object oEquipment, object oTackle)
{
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
    return TRUE;
}

// This is a configurable function to handle the animations for different stages
// of the fishing. nEvent is the fishing event which is currently playing:
// FISH_EVENT_START: plays when fishing begins (after OnFishingStart())
// FISH_EVENT_NIBBLE: plays when a fish has passed the nibble check
// FISH_EVENT_CATCH: plays when a PC successfully catches a fish
// FISH_EVENT_NO_CATCH: plays when a fish nibbled but was not caught
// FISH_EVENT_NO_NIBBLE: plays when no fish nibbled at all
void PlayFishingAnimation(int nEvent)
{
    switch (nEvent)
    {
        case FISH_EVENT_START:
            PlaySound("as_na_splash1");
            ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0, IntToFloat(Random(6) + 4));
            break;

        case FISH_EVENT_NIBBLE:
            ActionWait(1.0f);
            ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 0.1, 6.0);
            ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE);
            ActionWait(1.0f);
            break;

        case FISH_EVENT_CATCH:
            PlaySound("as_na_splash2");
            ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1);
            break;

        case FISH_EVENT_NO_CATCH:
            PlaySound("as_na_splash2");
            ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT);
            break;

        case FISH_EVENT_NO_NIBBLE:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED);
            break;

    }
}
