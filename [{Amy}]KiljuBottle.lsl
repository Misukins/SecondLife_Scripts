key owner;
key _id;
key openCap_Sound   = "36a82b3f-269c-a992-61a2-535825809028";
key closeCap_Sound  = "0b797841-25e8-3dfa-8745-cadbcd523d9a";
key drinking_Sound  = "34e7d853-6435-5386-d0c6-c32b316edc90";

integer _cap;
integer capON       = TRUE;
integer drinking    = FALSE;
integer kiljuAO_on  = FALSE;
integer isEmpty     = FALSE;
integer drunkTime   = 1200; //20minutes

integer listenid;
integer chan;
integer hand;
integer link_num;

float Volume = 1.0;
float updateInterval = 10.0;

list main_buttons       = [];
list main_admin_buttons = [];

string CAP_         = "Cap";
string drinkanim    = "drinkanim";
string drink        = "drink";
string rest         = "rest";

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
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    kiljuAO_on = FALSE;
    determine_bucket_links();
    doMenu(_id);
}

determine_bucket_links()
{
    integer i = link_num;
    integer found = 0;
    do {
        if(llGetLinkName(i) == CAP_){
            _cap = i;
            found++;
        }
    }
    while (i-- && found < 1);
}

CapOn()
{
    llSetLinkAlpha(_cap, 1, ALL_SIDES);
    capON = TRUE;
    llTriggerSound(closeCap_Sound, Volume);
}

CapOff()
{
    llSetLinkAlpha(_cap, 0, ALL_SIDES);
    capON = FALSE;
    llTriggerSound(openCap_Sound, Volume);
}

drinkKilju(key _id)
{
    isEmpty = TRUE;
    drinking = TRUE;
    kiljuAO_on = TRUE;
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llSetObjectName("");
    llSay(0, "/me " + (string)name + " drinks full bottle of kilju.");
    llSetObjectName("Kilju Bottle (empty)");
    llTriggerSound(drinking_Sound, Volume);
    llStopAnimation(rest);
    llSleep(0.1);
    llStartAnimation(drink);
    llSleep(15.0);
    llStopAnimation(drink);
    llMessageLinked(LINK_ROOT, 0, "KILJU_AOON", NULL_KEY);
    llSetTimerEvent(drunkTime);
}

timerRanOut()
{
    isEmpty = TRUE;
    drinking = FALSE;
    kiljuAO_on = FALSE;
    llMessageLinked(LINK_ROOT, 0, "KILJU_AOOFF", NULL_KEY);
    llSetTimerEvent(0);
    llSetObjectName("Kilju Bottle (empty)");
    llOwnerSay("This Bottle is empty!");
    llDie();
}

default
{
    state_entry()
    {
        llPreloadSound(openCap_Sound);
        llPreloadSound(closeCap_Sound);
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
            llSetObjectName("Kilju Bottle (empty)");
            llOwnerSay("This Bottle is empty!");
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS){
            llAttachToAvatar(ATTACH_RHAND);
            llStartAnimation(rest);
            if(isEmpty){
                llSetObjectName("Kilju Bottle (empty)");
                llOwnerSay("This Bottle is empty!");
                llDie();
            }
        }
        else{
            llResetAnimationOverride("ALL");
            llDie();
        }
    }

    attach(key _id){
        if((_id != NULL_KEY) && (isEmpty)){
            llSetObjectName("Kilju Bottle (empty)");
            llOwnerSay("This Bottle is empty!");
            llDie();
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
        else if (_message == "Close Cap"){
            CapOn();
            doMenu(_id);
        }
        else if ((!capON) && (_message == "Drink"))
            drinkKilju(_id);
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
