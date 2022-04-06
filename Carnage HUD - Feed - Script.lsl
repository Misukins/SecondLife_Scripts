key targetKey;

key VampireSuck  = "0171ceca-1a19-da02-b8f5-b78908cce022";

integer channel;
integer listen_handle;
integer dlgChannel;
integer ll_channel      = -458703;
integer dlgHandle       = -1;
integer listenChannel   = -4894566;
integer announced       = FALSE;
integer gotPermission   = FALSE;
integer DEBUG           = FALSE;
integer animON          = TRUE;
integer OwnerDead       = FALSE;
integer meterON         = FALSE;
integer playerFound;

integer random_chance(){
    if (llFrand(1.0) < 0.2)
        return TRUE;
    return FALSE;
}

string desc_    = "(c)Amy (meljonna Resident) - ";
string objectname;

list avatarList = [];
list avatarUUIDs = [];
list main_menu;
list settings_menu;

float updateInterval    = 1.0;
float FedCountdown      = 10.0; //DEFAULT 300SEC = 5min
float totalPenaltytime;
float blood             = 0.0;
float bloodMax          = 5.0;
float feedMin           = 0.25;
float feedMax           = 0.50;
float Volume            = 1.0;

vector color_USED       = <0.30, 0.30, 0.30>;
vector color_UNUSED     = <0.876, 0, 0>;

menu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    main_menu = ["Feed", "Settings", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option", main_menu, channel);
}

settingMenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(listen_handle);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    if(animON)
        settings_menu = ["■Anim", "NoAnim", "◄", "▼"];
    else
        settings_menu = ["Anim", "■NoAnim", "◄", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option", settings_menu, channel);
}

reset()
{
    llSetTimerEvent(0.0);
    llListenRemove(dlgHandle);
    dlgHandle = -1;
}

string Float2String ( float num, integer places, integer rnd)
{
    if (rnd){
        float f = llPow( 10.0, places );
        integer i = llRound(llFabs(num) * f);
        string s = "00000" + (string)i;
        if(num < 0.0)
            return "-" + (string)( (integer)(i / f) ) + "." + llGetSubString( s, -places, -1);
        return (string)( (integer)(i / f) ) + "." + llGetSubString( s, -places, -1);
    }
    if (!places)
        return (string)((integer)num );
    if ( (places = (places - 7 - (places < 1) ) ) & 0x80000000)
        return llGetSubString((string)num, 0, places);
    return (string)num;
}

string getFedTimeString(integer time)
{
    integer days;
    integer hours;
    integer minutes;
    integer seconds;
    days = llRound(time / 86400);
    time = time % 86400;
    hours = (time / 3600);
    time  = time % 3600;
    minutes = time / 60;
    time    = time % 60;
    seconds = time;
    return (string)minutes + " minutes";
}

default
{
    state_entry()
    {
        llSetLinkColor(LINK_THIS, color_UNUSED, ALL_SIDES);
        llSay(-458790, (string)Float2String(blood, 2, FALSE));
        if(llGetAttached())
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
        llSetText("", <0.0, 0.0, 0.0>, 0.0);
        llSetObjectDesc(desc_);
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        //llListen(listenChannel, "", llGetOwner(), "");
        llListen(ll_channel, "", "", "");
        llPreloadSound(VampireSuck);
        llResetTime();
    }

    changed(integer change)
    {
        if(change & CHANGED_OWNER)
            llResetScript();
    }

    attach(key _k)
    {
        if (_k != NULL_KEY){
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            if(blood <= feedMax){
                llSay(-458790, (string)Float2String(blood, 2, FALSE));
            }
            llSay(-458790, (string)Float2String(blood, 2, FALSE));
        }
    }

    run_time_permissions(integer _parm)
    {
        if(_parm == (PERMISSION_TRIGGER_ANIMATION)){
            gotPermission = TRUE;
            llStopAnimation("feed");
        }
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        if(meterON)
            menu(id);
        else
            llOwnerSay("Didn't find attachment: Carnage Meter");
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "▼")
            return;
        else if (message == "◄")
            menu(id);
        else if (message == "Settings")
            settingMenu(id);
        else if (message == "Anim"){
            animON = TRUE;
            menu(id);
        }
        else if (message == "NoAnim"){
            animON = FALSE;
            menu(id);
        }
        else if (message == "Feed"){
            list answer = llGetObjectDetails(targetKey,[OBJECT_POS]);
            if (id == llGetOwner()){
                llSensor("", NULL_KEY, AGENT, 1.0, PI);
                if (llGetListLength(answer) == 0){
                    if(!announced){
                        state default;
                    }
                    announced = TRUE;
                }
                else{
                    announced = FALSE;
                    state Feed;
                }
            }
        }
        else
            menu(id);

        if (channel == ll_channel){
            if(message == "meterON")
                meterON = TRUE;
            else if(message == "meterOFF")
                meterON = FALSE;

            //NOTE will be moved to METER
            /* if(message == "depositBlood1"){
                if(blood != 0.10){
                    if(blood > feedMin){
                        blood -= 1.0; //deposit 1 liter!
                        llShout(ll_channel, "OK");
                    }
                    else
                        llOwnerSay("you need to feed NOW!");
                }
                else
                    llOwnerSay("about to die!");
            }
            else if(message == "depositBlood1"){
                if(blood != 0.10){
                    if(blood > feedMin)
                        blood -= 0.25; //deposit .25 liter!
                    else
                        llOwnerSay("you need to feed NOW!");
                }
                else
                    llOwnerSay("about to die!");
            }
            else if(message == "depositBlood3"){
                if(blood != 0.10){
                    if(blood > feedMin)
                        blood -= 0.10; //deposit .10 liter!
                    else
                        llOwnerSay("you need to feed NOW!");
                }
                else
                    llOwnerSay("about to die!");
            }
            else if (message == "withdrawBlood1"){
                if(blood != bloodMax){
                    if(blood < bloodMax){
                        blood += 1.0;  //withdraw 1 liter!
                        if(blood > bloodMax)
                            blood = bloodMax;
                    }
                    else
                        llOwnerSay("you are full silly!");
                }
            }
            else if (message == "withdrawBlood2"){
                if(blood != bloodMax){
                    if(blood < bloodMax){
                        blood += 0.25;  //withdraw .25 liter!
                        if(blood > bloodMax)
                            blood = bloodMax;
                    }
                    else
                        llOwnerSay("you are full silly!");
                }
            }
            else if (message == "withdrawBlood3"){
                if(blood != bloodMax){
                    if(blood < bloodMax){
                        blood += 0.10;  //withdraw .10 liter!
                        if(blood > bloodMax)
                            blood = bloodMax;
                    }
                    else
                        llOwnerSay("you are full silly!");
                }
            } */
        }
    }

    no_sensor()
    {
        llOwnerSay("Did not find anyone");
    }

    sensor(integer num_detected)
    {
        playerFound = TRUE;
        state Feed;
    }
}

state Feed
{
    state_entry()
    {
        llListen(listenChannel, "", llGetOwner(), "");
        avatarList = [];
        avatarUUIDs = [];
        llSensor("", NULL_KEY, AGENT, 1.0, PI);
    }

    sensor(integer num_detected)
    {
        integer i;
        while((i < num_detected) && (i < 9)){
            if (llDetectedKey(i) != llGetOwner()){
                avatarList += [llDetectedName(i)];
                avatarUUIDs += [llDetectedKey(i)];
            }
            ++i;
        }
        if (llGetListLength(avatarList) > 0)
            state FeedDialog;
    }
}

state FeedDialog
{
    state_entry()
    {
        OwnerDead = FALSE;
        llListen(listenChannel, "", llGetOwner(), "");
        dlgHandle = llListen(dlgChannel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);
        avatarList += ["※Cancel"];
        llSetObjectDesc(desc_ + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + ".");
        llDialog(llGetOwner(), "Please select an avatar", avatarList, dlgChannel);
    }

    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if ((message != "※Cancel") && (!OwnerDead)){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                list targetName = [];
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                string origName = llGetObjectName();
                if(random_chance()){
                    llSetObjectName("");
                    llOwnerSay("You bit " + llGetDisplayName(targetKey) 
                    + " they resisted your bite, you got only " + (string)Float2String(feedMin, 2, FALSE) + " liters blood.");
                    llSetObjectName(origName);
                    llTriggerSound(VampireSuck, Volume);
                    if(animON){
                        llStartAnimation("feed");
                        llSleep(5);
                        llStopAnimation("feed");
                    }
                    llSay(-458790, "give_exp10");
                    llSay(-458790, "blood " + (string)Float2String(feedMin, 2, FALSE));
                    state JustFed;
                }
                else{
                    llSetObjectName("");
                    llOwnerSay("[SUCCESS]: You bit " + llGetDisplayName(targetKey) 
                    + " successfully, you got " + (string)Float2String(feedMax, 2, FALSE) + " liters blood.");
                    llSetObjectName(origName);
                    llTriggerSound(VampireSuck, Volume);
                    if(animON){
                        llStartAnimation("feed");
                        llSleep(5);
                        llStopAnimation("feed");
                    }
                    llSay(-458790, "give_exp20");
                    llSay(-458790, "blood " + (string)Float2String(feedMax, 2, FALSE));
                    state JustFed;
                }
            }
            else{
                reset();
                state default;
            }

        }
    }

    timer()
    {
        reset();
        state default;
    }
}

state JustFed
{
    state_entry()
    {
        totalPenaltytime = FedCountdown;
        llSetLinkColor(LINK_THIS, color_USED, ALL_SIDES);
        llOwnerSay("You just fed, you have to wait " + Float2String(totalPenaltytime, 0, FALSE) + " seconds, untill you can feed again.");
        llSetObjectDesc(desc_);
        llSetTimerEvent(updateInterval);
    }

    touch_start(integer total_number)
    {
        llOwnerSay("You just fed, you have to wait " + Float2String(totalPenaltytime, 0, FALSE) + " seconds, untill you can feed again.");
    }

    listen(integer channel, string name, key id, string message)
    {
        //TODO
        if (channel == ll_channel){
            if(message == "meterON")
                meterON = TRUE;
            else if(message == "meterOFF")
                meterON = FALSE;
        }
    }

    timer()
    {
        float timeElapsed = llGetAndResetTime();
        if (timeElapsed > (updateInterval * 4))
            timeElapsed = updateInterval;
            totalPenaltytime -= timeElapsed;
        if (totalPenaltytime <= 0){
            reset();
            state default;
            totalPenaltytime = FedCountdown;
            llSay(-458790, (string)Float2String(blood, 2, FALSE));
            llOwnerSay("A- " + (string)Float2String(blood, 2, FALSE));
        }
    }
}