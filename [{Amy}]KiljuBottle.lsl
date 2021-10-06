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
integer drunkTime   = 1800; //30minutes

integer listenid;
integer chan;
integer hand;
integer link_num;

float Volume = 1.0;
float updateInterval = 10.0;

list main_buttons       = [];
list main_admin_buttons = [];

string CAP_         = "Cap";
string drunkAO_     = "Drunk AO";
string drunkAO;
string drinkanim    = "drinkanim";
string drink        = "drink";
string rest         = "rest";

doMenu(key _id)
{
    if((capON) && (!isEmpty)){
        main_buttons =         [ "Open Cap", "▼" ];
        main_admin_buttons =   [ "Open Cap", "Reset", "▼" ];
    }
    else{
        main_buttons =         [ "Close Cap", "Drink", "▼" ];
        main_admin_buttons =   [ "Close Cap", "Drink", "Reset", "▼" ];
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
    llSetObjectName("Kilju Bottle (empty)");
    isEmpty = TRUE;
    drinking = TRUE;
    kiljuAO_on = TRUE;
    llTriggerSound(drinking_Sound, Volume);
    llStopAnimation(rest);
    llSleep(0.1);
    llStartAnimation(drinkanim);
    llSleep(15.0);
    llStopAnimation(drinkanim);
    llMessageLinked(LINK_ROOT, 0, "KILJU_AOON", NULL_KEY);
    llSetTimerEvent(drunkTime);
}

timerRanOut()
{
    drinking = FALSE;
    kiljuAO_on = FALSE;
    llMessageLinked(LINK_ROOT, 0, "KILJU_AOOFF", NULL_KEY);
    llDetachFromAvatar();
    llSetTimerEvent(0);
    llOwnerSay("This Bottle is empty!");
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

    changed(integer change)
    {
      if (change & CHANGED_OWNER)
          llResetScript();
    }

    on_rez(integer agent)
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        if(!isEmpty){
            _id = llDetectedKey(0);
            doMenu(_id);
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS){
            llAttachToAvatar(ATTACH_RHAND);
            llStartAnimation(rest);
        }
        else{
            llResetAnimationOverride("ALL");
            llResetScript();
        }
    }

    attach( key _id){
        if(isEmpty){
            llOwnerSay("This Bottle is empty!");
            llDetachFromAvatar();
        }
        if (_id != NULL_KEY)
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
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
        if (drunkTime <= 0)
            timerRanOut();
    }
}
