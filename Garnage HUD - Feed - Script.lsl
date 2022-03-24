key targetKey;

/*NOTE
low blood sound 
((
    i was thinking something like faint stomack growl at 10%
    then at 5% it gets louder...
))
*/
key warningSound ="e9a0c36a-dffc-eca0-27b5-3ba4d527dfad";

integer channel;
integer listen_handle;
integer dlgChannel;
integer ll_channel      = -98754465;
integer dlgHandle       = -1;
integer listenChannel   = -4894566;
integer announced       = FALSE;
integer gotPermission   = FALSE;
integer DEBUG           = FALSE;
integer animON          = TRUE;
integer OwnerDead       = FALSE;
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

/*NOTE
    You may change this time.
    float ONE_WEEK = 604800.0; //Week
    float ONE_DAY  = 86400.0;  //Day
    float ONE_HOUR = 3600.0;   //Hour
    float ONE_HHOUR = 1800.0;  //Half an Hours
    float ONE_MINUTE = 60.0;   //Minute
*/
//float ONE_DAY = 86394.0; //little less than 24hours
float totaltime;
float totalPenaltytime;
float ONE_DAY           = 86394.0;
float updateInterval    = 5.0;
float FedCountdown      = 300.0; //DEFAULT 300SEC = 5min
float blood             = 2.0;
float bloodMax          = 5.0;
float feedMin           = 0.1;
float feedMax           = 0.25;

vector titleColor       = <0.905, 0.686, 0.924>; //will be removed 

menu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", _id, "");
    main_menu = ["Feed", "Settings", "▼"];
    llDialog(_id, "Hello " + (string)avatar_name + " Select an option\nCurrent Blood volume :: "
        + (string)Float2String(blood, 2, FALSE) + "/"
        + (string)Float2String(bloodMax, 2, FALSE) + 
        " liters(s)", main_menu, channel);
}

settingMenu(key _id)
{
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
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

saveData()
{
    list saveData;
    saveData += llRound(blood);
    llSetObjectDesc(desc_ + llDumpList2String(saveData, ","));
}

dispString(string value)
{
    llSetText(value, titleColor, 1);
}

string getTimeString(integer time)
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
    return (string)hours + " hours, " + (string)minutes + " minutes";
}

updateTimeDisp()
{
    dispString(
        "[DEBUG]: BLOOD: " + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + "\n"
        +"You will die in:\n" 
        + getTimeString(llRound(totaltime))
        +"\nThis is set to 10seconds for testing\nobject text will be removed once im tested this fully!"
        );
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

FedUpdateTimeDisp()
{
    dispString(
        "[DEBUG]: just fed penalty till: "
        + getFedTimeString(llRound(totalPenaltytime))
        );
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

default
{
    state_entry()
    {
        //if(llGetAttached())
        //    llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
        llSetText("", <0.0, 0.0, 0.0>, 0.0);
        llSetObjectDesc(desc_ + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + ".");
        llMessageLinked(LINK_SET, 0, (string)Float2String(blood, 2, FALSE), NULL_KEY);
        dlgChannel = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        llParticleSystem([]);
        llListen(listenChannel, "", llGetOwner(), "");
        llListen(ll_channel, "", "", "");
        if(DEBUG)
            updateTimeDisp();
        llResetTime();
        llSetTimerEvent(updateInterval);
        OwnerDead = FALSE;
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
                llOwnerSay("You need to Feed soon!");
                llTriggerSound(warningSound, 1.0);
            }
            llOwnerSay("Current Blood: "
                + (string)Float2String(blood, 2, FALSE) + "/"
                + (string)Float2String(bloodMax, 2, FALSE) + ".");
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
        menu(id);
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
            if(message == "depositBlood1"){
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
            }
        }
    }

    no_sensor()
    {
        llOwnerSay("Did not find anyone");
    }

    sensor(integer num_detected)
    {
        state Feed;
    }

    timer()
    {
        float timeElapsed = llGetAndResetTime();
        if (timeElapsed > (updateInterval * 4))
            timeElapsed = updateInterval;
        totaltime -= timeElapsed;
        if (totaltime <= 0){
            blood -= feedMax;
            totaltime = ONE_DAY;
            saveData();
            if(DEBUG)
                updateTimeDisp();
        }
        if(DEBUG)
            updateTimeDisp();

        if(blood <= 0){
            blood = 0.0;
            state Death;
        }
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

    /* no_sensor()
    {
        llOwnerSay("Did not find anyone");
        state default;
    } */
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
        llDialog(llGetOwner(), "Please select an avatar you want\nCurrent Blood volume :: " + (string)Float2String(blood, 2, FALSE) + "/"
        + (string)Float2String(bloodMax, 2, FALSE) + " liters(s)", avatarList, dlgChannel);
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
                //ACTIONS HERE!!!
                if(random_chance()){
                    if(blood != bloodMax){
                        if(blood < bloodMax){
                            blood += feedMin;
                            if(blood > bloodMax)
                                blood = bloodMax;
                            llSetObjectName("");
                            llOwnerSay("[RESIST]: You bit " + llGetDisplayName(targetKey) + ", you got only " + (string)Float2String(feedMin, 2, FALSE) + " liters blood of total 5 liters.");
                            llSetObjectName(origName);
                            totaltime = ONE_DAY;
                            saveData();
                            if(animON){
                                llStartAnimation("feed");
                                llSleep(5);
                                llStopAnimation("feed");
                            }
                            if(DEBUG)
                                llOwnerSay("SUCCESS: " + (string)Float2String(feedMin, 2, FALSE));
                            llMessageLinked(LINK_SET, 0, (string)Float2String(feedMin, 2, FALSE), NULL_KEY);
                            state JustFed;
                        }
                    }
                }
                else{
                    if(blood != bloodMax){
                        if(blood < bloodMax){
                            blood += feedMax;
                            if(blood > bloodMax)
                                blood = bloodMax;
                            llSetObjectName("");
                            llOwnerSay("[SUCCESS]: You bit " + llGetDisplayName(targetKey) + ", you got " + (string)Float2String(feedMax, 2, FALSE) + " liters blood of total 5 liters.");
                            llSetObjectName(origName);
                            totaltime = ONE_DAY;
                            saveData();
                            if(animON){
                                llStartAnimation("feed");
                                llSleep(5);
                                llStopAnimation("feed");
                            }
                            if(DEBUG)
                                llOwnerSay("SUCCESS: " + (string)Float2String(feedMax, 2, FALSE));
                            llMessageLinked(LINK_SET, 0, (string)Float2String(feedMax, 2, FALSE), NULL_KEY);
                            state JustFed;
                        }
                    }
                }
            }
            else{
                if(OwnerDead){
                    llOwnerSay("You are still Dead you really need to find somebody!");
                    blood = 0.0;
                    state Death;
                }
                else{
                    reset();
                    state default;
                }

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
        if(DEBUG)
            FedUpdateTimeDisp();
        totalPenaltytime = FedCountdown;
        llOwnerSay("You just fed, you have to wait "
            + Float2String(totalPenaltytime, 0, FALSE) + " seconds, untill you can feed again\nCurrent Blood: "
            + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + ".");
        llSetObjectDesc(desc_ + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + ".");
        llSetTimerEvent(updateInterval);
    }

    touch_start(integer total_number)
    {
        llOwnerSay("You just fed, you have to wait "
            + Float2String(totalPenaltytime, 0, FALSE) + " seconds, untill you can feed again\nCurrent Blood: "
            + (string)Float2String(blood, 2, FALSE) + "/" + (string)Float2String(bloodMax, 2, FALSE) + ".");
    }

    listen(integer channel, string name, key id, string message)
    {
        if (channel == ll_channel){
            if(message == "depositBlood1"){
                if(blood != 0.10){
                    if(blood > feedMin)
                        blood -= 1.0; //deposit 1 liter!
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
            }
        }
    }

    timer()
    {
        float timeElapsed = llGetAndResetTime();
        if (timeElapsed > (updateInterval * 4))
            timeElapsed = updateInterval;
            totalPenaltytime -= timeElapsed;
        if (totalPenaltytime <= 0){
            llOwnerSay("You sense fresh blood nearby!");
            reset();
            state default;
            totalPenaltytime = FedCountdown;
            totaltime = ONE_DAY;
            saveData();
            if(DEBUG)
                FedUpdateTimeDisp();
        }
        
        if(DEBUG)
            FedUpdateTimeDisp();
    }
}

state Death
{
    state_entry()
    {
        llListen(ll_channel, "", "", "");
        OwnerDead = TRUE;
        llTriggerSound(warningSound, 1.0);
        llSetTimerEvent(0.0);
        llSetObjectDesc(desc_ + "DEAD");
        if(DEBUG)
            llSetText("[DEBUG]: you are dead.. no what?", <1.0, 0.0, 0.0>, 1.0);
    }

    touch_start(integer total_number)
    {
        list answer = llGetObjectDetails(targetKey,[OBJECT_POS]);
        llSensor("", NULL_KEY, AGENT, 1.0, PI);
        if (llGetListLength(answer) == 0)
            announced = TRUE;
        else{
            announced = FALSE;
            state Feed;
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if ((channel == dlgChannel) && (llListFindList(avatarList, [message]) != -1)){
            if (message != "※Cancel"){
                list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
                list targetName = [];
                targetName += [message];
                string targetID = (key)llList2String(targetName,0);
                targetKey = llName2Key(targetID);
                string origName = llGetObjectName();
                //ACTIONS HERE!!!
                if(random_chance()){
                    if(blood != bloodMax){
                        if(blood < bloodMax){
                            blood += feedMin;
                            if(blood > bloodMax)
                                blood = bloodMax;
                        }
                        llSetObjectName("");
                        llOwnerSay("[RESIST]: You bit " + llGetDisplayName(targetKey) + ", you got only " + (string)Float2String(feedMin, 2, FALSE) + " liters blood of total 5 liters.");
                        llSetObjectName(origName);
                        state JustFed;
                    }
                }
                else{
                    if(blood != bloodMax){
                        if(blood < bloodMax){
                            blood += feedMax;
                            if(blood > bloodMax)
                                blood = bloodMax;
                        }
                        llSetObjectName("");
                        llOwnerSay("[SUCCESS]: You bit " + llGetDisplayName(targetKey) + ", you got " + (string)Float2String(feedMax, 2, FALSE) + " liters blood of total 5 liters.");
                        llSetObjectName(origName);
                        state JustFed;
                    }
                }
                totaltime = ONE_DAY;
                saveData();
            }
        }

        if (channel == ll_channel){
            if (message == "withdrawBlood1"){
                if(blood != bloodMax){
                    if(blood < bloodMax){
                        blood += 1.0;  //withdraw 1 liter!
                        if(blood > bloodMax)
                            blood = bloodMax;
                        llSetTimerEvent(updateInterval);
                    }
                    else
                        llOwnerSay("you are full silly!");
                }
            }
        }
    }

    no_sensor()
    {
        llOwnerSay("Did not find anyone");
    }

    sensor(integer num_detected)
    {
        state Feed;
    }

    timer()
    {
        llOwnerSay("Current Blood volume :: "
        + (string)Float2String(blood, 2, FALSE) + "/"
        + (string)Float2String(bloodMax, 2, FALSE) + 
        " liters(s), You need to feed soon!");
        saveData();
        reset();
        state default;
    }
}
