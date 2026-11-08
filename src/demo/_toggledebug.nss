int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int bDebug = GetLocalInt(oPC, "DEBUG");
    SetLocalInt(oPC, "DEBUG", !bDebug);
    SetCustomToken(10000, (bDebug ? "off" : "on"));
    return TRUE;
}


