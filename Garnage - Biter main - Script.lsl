
string WeaponType = "sword"; 
string DamageType = "sword"; 
string SubDamageType = "sword"; 
string Stance = ""; 
string HitSound = "teethchatter";
string MissSound = "vamproar";
string AttackAnimation = "vampbite01s";
string DrawSound = "hungerdraw"; 
string SheathSound = "wolfsheath"; 

float SoundVolume = 1.0;
float Range = 1.5; 
float Speed = 0.55; 

integer Drawn = FALSE;
integer AutoSheathOnRez = TRUE; 
integer listenChannel   = -458789;
integer llChan          = -458701;

integer DynamicChannel()
{
    integer dyn;
    dyn = (integer)("0x" + llGetSubString((string)llDetectedKey(0),0,7));
    return dyn;
}

Attack()
{
    llResetTime();
    llSensor("",NULL_KEY,AGENT,Range,PI_BY_TWO);
    llStartAnimation(AttackAnimation);
}


default
{
    state_entry()
    {
        if(llGetAttached())
            llSay(llChan, "biterON");
        if(AutoSheathOnRez)
            llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
        llListen(PUBLIC_CHANNEL,"",llGetOwner(),"");
        llListen(1,"",llGetOwner(),"");
        llListen(listenChannel, "", NULL_KEY, "");
    }
    
    on_rez(integer rez)
    {
        llResetScript();
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        if(msg == llToLower("draw "+WeaponType) && !Drawn){
            Drawn = TRUE;
            if(DrawSound!="")
                llPlaySound(DrawSound,SoundVolume);
            llSetLinkAlpha(LINK_SET,1,ALL_SIDES);
            llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
        }
        if(msg == llToLower("sheath "+WeaponType) && Drawn){
            Drawn = FALSE;
            llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
            if(SheathSound!="")
                llPlaySound(SheathSound,SoundVolume);
            if(Stance!="")
                llStopAnimation(Stance);
            llRequestPermissions(llGetOwner(),  FALSE);
        }
    }
    
    run_time_permissions(integer permition)
    {
        if (permition){
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON, TRUE, TRUE); 
            if(Stance!="")
                llStartAnimation(Stance);
        }
        else
            llReleaseControls();
    }
    
    attach(key okey)
    {
        if (okey != NULL_KEY)
            llSay(llChan, "biterON");
        else
            llSay(llChan, "biterOFF");
        
        if(okey == NULL_KEY && Drawn){
            if(Stance!="")
                llStopAnimation(Stance);
            llRequestPermissions(llGetOwner(), FALSE); 
            llSetLinkAlpha(LINK_SET, 0, ALL_SIDES);
        }
    }
    
    control(key id, integer down, integer change)
    {
        integer pressed = down & change;
        if(llGetTime()<Speed)
            return;
        if((pressed) & (CONTROL_ML_LBUTTON | CONTROL_LBUTTON))
            Attack();
    }
    
    sensor(integer tnum)
    {
        string struck = llDetectedName(0);
        string attacker = llKey2Name(llGetOwner());
        llShout(DynamicChannel(),DamageType+","+attacker+","+struck+","+SubDamageType);
        llTriggerSound(HitSound,SoundVolume);
    }
    
    no_sensor()
    {
        llTriggerSound(MissSound,SoundVolume);
    }
}
