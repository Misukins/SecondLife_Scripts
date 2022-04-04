key twin                = "4dfe6649-d46c-b35f-5014-11c3c67ad8a9";
key fireballcast        = "984f9ec3-6997-fbae-c2c8-ab11034f16c0";

float cast_coolDown     = 10.0;

integer llChan          = -458704;
integer listenChannel   = -458790;
integer casterON        = FALSE;
integer gotPermission   = FALSE;

vector color_USED       = <0.30, 0.30, 0.30>;
vector color_UNUSED     = <1, 1, 1>;
vector color_ONCOOLDOWN = <0, 0, 0>;

cast()
{
    llSay(listenChannel, "BloodBall_Casted");
    llTriggerSound(fireballcast, 1.0);
    llSay(330, llKey2Name(llGetOwner())+ "shoot");
    llStartAnimation("Attack11");
}   

default
{
    state_entry()
    {
        llSetLinkColor(LINK_THIS, color_UNUSED, ALL_SIDES);
        llListen(llChan, "", "", "");
        llListen(listenChannel, "", "", "");
        llPreloadSound(fireballcast);
        llPreloadSound(twin);
        if(llGetAttached())
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        if((casterON) && (gotPermission)){
            cast();
            state CoolDown;
        }
        else
            llOwnerSay("Didn't find attachment: Carnage Caster");
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION){
            gotPermission = TRUE;
            llStopAnimation("Attack11");
        }
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(chan == llChan){
            if(msg == "casterON")
                casterON = TRUE;
            else if(msg == "casterOFF")
                casterON = FALSE;
        }
        if(chan == listenChannel){
            if(msg == "noBlood")
                state noBlood;
        }
    }
}

state noBlood
{
    state_entry()
    {
        llListen(llChan, "", "", "");
        llListen(listenChannel, "", "", "");
        llSetLinkColor(LINK_THIS, color_USED, ALL_SIDES);
        llOwnerSay("You are out of Blood!");
    }

    listen(integer chan, string name, key id, string msg)
    {
        if(chan == llChan){
            if(msg == "casterON")
                casterON = TRUE;
            else if(msg == "casterOFF")
                casterON = FALSE;
        }

        if(chan == listenChannel){
            if(msg == "okBlood")
                state default;
        }
    }
}

state CoolDown
{
    state_entry()
    {
        llSetTimerEvent(cast_coolDown);
        llStopAnimation("Attack11");
        llStopSound();
        llSetLinkColor(LINK_THIS, color_ONCOOLDOWN, ALL_SIDES);
    }

    timer()
    {
        state default;
    }
}