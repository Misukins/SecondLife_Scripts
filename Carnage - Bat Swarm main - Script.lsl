string WeaponType       = "bats";
string DamageType       = "bats";
string SubDamageType    = "sword";
string HitSound         = "hit";
string MissSound        = "swingmiss2";
string DrawSound        = "draw1";
string SheathSound      = "sheath";

float SoundVolume   = 1.0;
float Range         = 2.5;
float Speed         = 0.55;
float bats_duration = 20.0; //NOTE 20seconds or if out of stamina

integer Drawn           = FALSE;
integer AutoSheathOnRez = TRUE;
integer listenChannel   = -458790;
integer llChan          = -458702;

integer DynamicChannel()
{
    integer dyn;
    dyn = (integer)("0x" + llGetSubString((string)llDetectedKey(0),0,7));
    return dyn;
}

Attack()
{
    llResetTime();
    llSensor("", NULL_KEY,AGENT, Range, PI_BY_TWO);
    llSay(listenChannel, "give_exp4");
}

default
{
    state_entry()
    {
        if(llGetAttached()){
            llSay(llChan, "batsON");
        }
        if(AutoSheathOnRez)
            llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
        /*
        //NOTE UNUSED
        llListen(PUBLIC_CHANNEL,"", llGetOwner(), "");
        llListen(1,"", llGetOwner(), "");
        */
        llListen(listenChannel, "", "", "");
        llTargetOmega(<0, 0, 0>, 0, 0);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        llResetScript();
    }

    on_rez(integer rez)
    {
        llResetScript();
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(chan == listenChannel){
            if(llGetOwnerKey(id) == llGetOwner()){
                if(msg == llToLower("draw "+ WeaponType) && !Drawn){
                    Drawn = TRUE;
                    if(DrawSound != "")
                        llPlaySound(DrawSound,SoundVolume);
                    llSetLinkAlpha(LINK_SET, 1, ALL_SIDES);
                    llTargetOmega(<0, 0, 1>, PI, 1.0);
                    Attack();
                    llSay(listenChannel, "Bats_Active");
                    llSetTimerEvent(bats_duration);
                }
                else if(msg == llToLower("sheath "+ WeaponType) && Drawn){
                    Drawn = FALSE;
                    llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                    if(SheathSound != "")
                        llPlaySound(SheathSound,SoundVolume);
                    llSay(listenChannel, "Bats_Deactive");
                    llTargetOmega(<0, 0, 0>, 0, 0);
                }
                else if(msg == "noMana"){
                    Drawn = FALSE;
                    llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
                    if(SheathSound != "")
                        llPlaySound(SheathSound, SoundVolume);
                    llTargetOmega(<0, 0, 0>, 0, 0);
                    llSay(listenChannel, "Bats_Deactive");
                    llOwnerSay("You are out of Stamina!");
                }
            }
        }
    }

    attach(key okey)
    {
        if (okey != NULL_KEY)
            llSay(llChan, "batsON");
        else
            llSay(llChan, "batsOFF");
        if(okey == NULL_KEY && Drawn){
            llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
        }
    }

    sensor(integer tnum)
    {
        string struck = llDetectedName(0);
        string attacker = llKey2Name(llGetOwner());
        if(Drawn){
            llShout(DynamicChannel(), DamageType + "," + attacker + "," + struck + "," + SubDamageType);
            llTriggerSound(HitSound, SoundVolume);
            llSleep(2);
            Attack();
        }
    }

    no_sensor()
    {
        if(Drawn)
            llTriggerSound(MissSound, SoundVolume);
    }

    timer()
    {
        if(Drawn){
            Drawn = FALSE;
            llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
            if(SheathSound != "")
                llPlaySound(SheathSound, SoundVolume);
            llTargetOmega(<0, 0, 0>, 0, 0);
            llSay(listenChannel, "Bats_Deactive");
        }
        llSetTimerEvent(0.0);
    }
}