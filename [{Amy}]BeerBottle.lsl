key owner;
key _id;
key openCap_Sound   = "b44c9095-6acf-6fa2-28f9-b435948de194";
key drinking_Sound  = "34e7d853-6435-5386-d0c6-c32b316edc90";

integer _cap;
integer capON       = TRUE;
integer drinking    = FALSE;
integer BeerAO_on   = FALSE;
integer isEmpty     = FALSE;
integer drunkTime   = 600; //10minutes

integer listenid;
integer chan;
integer hand;

float Volume = 1.0;
float updateInterval = 10.0;

list main_buttons       = [];
list main_admin_buttons = [];

string CAP_         = "Cap";
string drinkanim    = "drinkanim";
string drink        = "drink";
string rest         = "rest";
string objectName   = "[{Amy}]BeerBottle";
string objectEmpty  = "BeerBottle (empty)";
string origName;

doMenu(key _id)
{
    if(capON){
        main_buttons =         [ "Open Cap", "▼" ];
        main_admin_buttons =   [ "Open Cap", "▼" ];
    }
    else{
        main_buttons =         [ "Close Cap", "Drink", "▼" ];
        main_admin_buttons =   [ "Close Cap", "Drink", "▼" ];
    }
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    if ( _id == llGetOwner())
        llDialog(_id, (string)owner_name + "'s Bottle Cap Menu\nChoose an option! " + (string)name + "?", main_admin_buttons, chan);
    else
        llDialog(_id, (string)owner_name + "'s Bottle Cap Menu\nChoose an option! " + (string)name + "?", main_buttons, chan);
}

init()
{
    _id = llDetectedKey(0);
    BeerAO_on = FALSE;
    doMenu(_id);
}

CapOff()
{
    capON = FALSE;
    llTriggerSound(openCap_Sound, Volume);
}

drinkBeer(key _id)
{
    isEmpty = TRUE;
    drinking = TRUE;
    BeerAO_on = TRUE;
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    origName = llGetObjectName();
    llSetObjectName("");
    llSay(0, "/me " + (string)name + " drinks full bottle of beer.");
    llTriggerSound(drinking_Sound, Volume);
    llStopAnimation(rest);
    llSleep(0.1);
    llStartAnimation(drink);
    llSleep(15.0);
    llStopAnimation(drink);
    llMessageLinked(LINK_ROOT, 0, "BEER_AOON", NULL_KEY);
    llSetPrimitiveParams([PRIM_NAME, objectEmpty]);
    llSetTimerEvent(drunkTime);
}

timerRanOut()
{
    isEmpty = TRUE;
    drinking = FALSE;
    BeerAO_on = FALSE;
    llMessageLinked(LINK_ROOT, 0, "BEER_AOOFF", NULL_KEY);
    llSetTimerEvent(0);
    llSetPrimitiveParams([PRIM_NAME, objectEmpty]);
    llSetObjectName(objectEmpty);
    llOwnerSay("This Bottle is empty!");
    llDetachFromAvatar();
}

default
{
    state_entry()
    {
        llPreloadSound(openCap_Sound);
        llPreloadSound(drinking_Sound);
        llRequestPermissions(llGetOwner(), PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
        init();
    }

    touch_start(integer total_number)
    {
        if(!isEmpty){
            _id = llDetectedKey(0);
            doMenu(_id);
        }
        else{
            origName = llGetObjectName();
            llSetObjectName(objectEmpty);
            llSetPrimitiveParams([PRIM_NAME, objectEmpty]);
            llOwnerSay("This Bottle is empty!");
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS){
            llAttachToAvatar(ATTACH_RHAND);
            llStartAnimation(rest);
            if(isEmpty){
                origName = llGetObjectName();
                llSetObjectName(objectEmpty);
                llSetPrimitiveParams([PRIM_NAME, objectEmpty]);
                llOwnerSay("This Bottle is empty!");
                llDetachFromAvatar();
            }
        }
        else{
            llResetAnimationOverride("ALL");
            llDetachFromAvatar();
        }
    }

    attach(key _id){
        if((_id != NULL_KEY) && (isEmpty)){
            origName = llGetObjectName();
            llSetObjectName(objectEmpty);
            llSetPrimitiveParams([PRIM_NAME, objectEmpty]);
            llOwnerSay("This Bottle is empty!");
            llDetachFromAvatar();
        }
        else if ((_id != NULL_KEY) && (!isEmpty)){
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            doMenu(_id);
        }
    }
    
    listen(integer _channel, string _name, key _id, string _message)
    {
        if (_message == "Open Cap"){
            CapOff();
            doMenu(_id);
        }
        else if ((!capON) && (_message == "Drink"))
            drinkBeer(_id);
        else if (_message == "Reset")
            llResetScript();
        else if (_message == "▼")
            return;
    }

    timer()
    {
        float timeElapsed = llGetAndResetTime();
        if (timeElapsed > (updateInterval * 4))
            timeElapsed = updateInterval;
            drunkTime -= drunkTime;
        if (drunkTime <= 0){
            timerRanOut();
        }
    }
}
