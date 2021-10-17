/*---------- PLEASE DO NOT CHANGE ANYTHING FROM HERE ----------*/
key owner;
key makersID;
key readKey;
key lid_ON_Sound        = "36abc63f-7536-2ee9-efc4-d0fdb98c5767";
key lid_OFF_Sound       = "549679ab-2d75-d3ec-b6e6-76c89a0759e2";
key MakinngKilju_Sound  = "62adc742-ccee-3a69-e64b-b70b885a07cf";

string LID_             = "Lid";
string WATER_           = "Water";
string YEAST_           = "Yeast";
string SUGAR_           = "Sugar";
string KiljuBottle      = "[{Amy}]Kilju Bottle";
string objectname;
string makersName;

integer listenid;
integer chan;
integer hand;
integer link_num;

integer _lid;
integer _water;
integer _yeast;
integer _sugar;

integer LidON = TRUE; // TRUE = 1 / FALSE = 0 :: on debug!
integer KILJUReady = FALSE;
integer WATERadded = FALSE;
integer YEASTcount = 0;
integer SUGARcount = 0;
integer WATERcount = 0;

float cookingtime;
float Volume = 1.0;

list main_buttons       = [];
list main_admin_buttons = [];
list mainKilju_buttons  = [];
/*---------- TO HERE ----------*/
/*NOTE
    You may change this time.
    float ONE_WEEK = 604800.0; //Week
    float ONE_DAY  = 86400.0;  //Day
    float ONE_HOUR = 3600.0;   //Hour
    float ONE_HHOUR = 1800.0;  //Half an Hours
    float ONE_MINUTE = 60.0;   //Minute
*/
float ONE_DAY = 86394.0; //little less than 24hours
float updateInterval = 30.0; //DEFAULT 30SEC

vector titleColor = <0.905, 0.686, 0.924>;

doMenu(key _id)
{
    if ((LidON) && (WATERadded)){
        main_buttons =         [ "Finished", "▼" ];
        main_admin_buttons =   [ "Finished", "Reset", "▼" ];
    }
    else if(LidON){
        main_buttons =         [ "Open Lid", "▼" ];
        main_admin_buttons =   [ "Open Lid", "Reset", "▼" ];
    }
    else{
        main_buttons =         [ "Close Lid", "Water", "Yeast", "Sugar", "▼" ];
        main_admin_buttons =   [ "Close Lid", "Water", "Yeast", "Sugar", "Reset", "▼" ];
    }
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    if ( _id == llGetOwner()){
        llDialog(_id, (string)owner_name + "'s Kilju Making Menu\n
        Current Recipe:\n"
        + (string)YEASTcount + " Yeast "
        + (string)SUGARcount + " Sugar "
        + (string)WATERcount + " Water\n
        Choose an option! " + (string)name + "?", main_admin_buttons, chan);
    }
    else{
        llDialog(_id, (string)owner_name + "'s Kilju Making Menu\n
        Current Recipe:\n"
        + (string)YEASTcount + " Yeast "
        + (string)SUGARcount + " Sugar "
        + (string)WATERcount + " Water\n
        Choose an option! " + (string)name + "?", main_buttons, chan);
    }
}

doKiljuRDYMenu(key _id)
{
    if (_id == makersID)
        mainKilju_buttons = [ "Check", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    llDialog(_id, (string)owner_name + "'s Kilju Making Menu\n
    Current Recipe:\n"
    + (string)YEASTcount + " Yeast. "
    + (string)SUGARcount + " Sugar. "
    + (string)WATERcount + " Water.\n
    Choose an option! " + (string)name + "?", mainKilju_buttons, chan);
}

init()
{
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    llSetText("", titleColor, 1);
    llSetObjectDesc("");
    determine_bucket_links();
    KILJUReady = FALSE;
    WATERadded = FALSE;
    YEASTcount = 0;
    SUGARcount = 0;
    WATERcount = 0;
    lidOn();
}

determine_bucket_links()
{
    integer i = link_num;
    integer found = 0;
    do {
        if(llGetLinkName(i) == LID_){
            _lid = i;
            found++;
        }
        else if (llGetLinkName(i) == WATER_){
            _water = i;
            found++;
        }
        else if (llGetLinkName(i) == YEAST_){
            _yeast = i;
            found++;
        }
        else if(llGetLinkName(i) == SUGAR_){
            _sugar = i;
            found++;
        }
    }
    while (i-- && found < 4);
    llSetLinkAlpha(_water, 0, ALL_SIDES);
    llSetLinkAlpha(_yeast, 0, ALL_SIDES);
    llSetLinkAlpha(_sugar, 0, ALL_SIDES);
}

lidOn()
{
    llSetLinkAlpha(_lid, 1, ALL_SIDES);
    llTriggerSound(lid_ON_Sound, Volume);
    LidON = TRUE;
}

lidOff()
{
    llSetLinkAlpha(_lid, 0, ALL_SIDES);
    llTriggerSound(lid_OFF_Sound, Volume);
    LidON = FALSE;
}

addWater()
{
    if(!WATERadded){
        WATERadded = TRUE;
        llSetLinkAlpha(_water, 1, ALL_SIDES);
    }
    if(WATERcount < 6){
        WATERcount += 1;
        llSay(0, "You added some water. :: Total water: " + (string)WATERcount + ".");
    }
    else
        llSay(0, "You tryed to add too much water, it would overfill.");
        WATERcount = WATERcount++;
}

addYeast()
{
    if(YEASTcount < 5){
        YEASTcount += 1;
        llSetLinkAlpha(_yeast, 1, ALL_SIDES);
        llSay(0, "You added some yeast. :: Total yeast: " + (string)YEASTcount + ".");
    }
    else
        llSay(0, "You tryed to add too much yeast.");
    YEASTcount = YEASTcount++;
}

addSugar()
{
    if(SUGARcount < 10){
        SUGARcount += 1;
        llSetLinkAlpha(_sugar, 1, ALL_SIDES);
        llSay(0, "You added some sugar. :: Total sugar: " + (string)SUGARcount + ".");
    }
    else
        llSay(0, "You tryed to add too much sugar.");
    SUGARcount = SUGARcount++;
}

dispString(string value)
{
    llSetText(value, titleColor, 1);
}

saveData()
{
    list saveData;
    saveData += (string)YEASTcount + " Yeast";
    saveData += (string)SUGARcount + " Sugar";
    saveData += (string)WATERcount + " Water";
    saveData += (key)makersID;
    saveData += (string)makersName;
    saveData += llRound(cookingtime);
    llSetObjectDesc(llDumpList2String(saveData, ","));
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
    list userName = llParseString2List(llGetDisplayName(makersID), [""], []);
    dispString(
        (string)WATERcount + " Water. "
        + (string)YEASTcount + " Yeast. "
        + (string)SUGARcount + " Sugar.\n"
        + (string)userName + " (" + makersName + ")\n
        Kilju will be ready in:\n" 
        + getTimeString(llRound(cookingtime)));
}

default
{
    state_entry()
    {
        llPreloadSound(lid_ON_Sound);
        llPreloadSound(lid_OFF_Sound);
        llPreloadSound(MakinngKilju_Sound);
        init();
    }

    on_rez(integer num)
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        key _id = llDetectedKey(0);
        doMenu(_id);
    }

    listen(integer _channel, string _name, key _id, string _message)
    {
        if (_message == "Open Lid"){
            lidOff();
            doMenu(_id);
        }
        else if (_message == "Close Lid"){
            lidOn();
            doMenu(_id);
        }
        else if ((_message == "Water") && (!LidON)){
            addWater();
            doMenu(_id);
        }
        else if ((_message == "Yeast") && (!LidON)){
            addYeast();
            doMenu(_id);
        }
        else if ((_message == "Sugar") && (!LidON)){
            addSugar();
            doMenu(_id);
        }
        else if ((_message == "Finished") && (LidON) && (WATERadded == TRUE)){
            makersID   = _id;
            makersName = llKey2Name(makersID);
            cookingtime = ONE_DAY;
            saveData();
            state MakingKilju;
        }
        else if (_message == "Reset")
            llResetScript();
        else if (_message == "▼")
            return;
    }
}

state MakingKilju
{
    state_entry()
    {
        updateTimeDisp();
        llResetTime();
        llSetTimerEvent(updateInterval);
    }

    timer()
    {
        float timeElapsed = llGetAndResetTime();
        if (timeElapsed > (updateInterval * 4))
            timeElapsed = updateInterval;
        cookingtime -= timeElapsed;
        updateTimeDisp();
        llTriggerSound(MakinngKilju_Sound, Volume);
        if (cookingtime <= 0)
            state KiljuReady;
    }
}

state KiljuReady
{
    state_entry()
    {
        KILJUReady = TRUE; //just in case if i add more features with this.
        list userName = llParseString2List(llGetDisplayName(makersID), [""], []);
        llSetText(
              (string)WATERcount + " Water.\n"
            + (string)YEASTcount + " Yeast.\n"
            + (string)SUGARcount + " Sugar.\n"
            + (string)userName + " (" + makersName + ")\n
                Kilju is ready!", titleColor, 1);
        llGetObjectDesc();
    }

    
    dataserver(key requested, string data)
    {
        list savedList = llParseString2List(llGetObjectDesc(), [","], []);
        if (llGetListLength(savedList) == 6){
            YEASTcount      = llList2Integer(savedList, 1);
            SUGARcount      = llList2Integer(savedList, 2);
            WATERcount      = llList2Integer(savedList, 3);
            makersID        = llList2Key(savedList, 4);
            makersName      = llList2String(savedList, 5);
            cookingtime     = llList2Integer(savedList, 6);
        }
    }

    touch_start(integer num_detected)
    {
        key _id = llDetectedKey(0);
        list userName = llParseString2List(llGetDisplayName(makersID), [""], []);
        if(_id == makersID)
            doKiljuRDYMenu(_id);
        else
            return;
    }

    listen(integer _channel, string _name, key _id, string _message)
    {
        string origName = llGetObjectName();
        if(_message == "Check"){
            lidOff();
            llSetObjectName("Pena");
            llSay(0, "/me Let me taste it..");
            llSleep(8.0);
            llSay(0, "/me *drinks*");
            llSleep(10.0);
            if((WATERcount == 4) && (YEASTcount == 1) && (SUGARcount == 6)){ //perfect
                llSay(0, "/me This is VeryGood shit!");
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
            }
            //i might need more of these.. but really????
            else if ((YEASTcount == 1) && (SUGARcount < 6))
            {
                llSay(0, "/me You added too little sugar.");
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
            }
            else if ((YEASTcount > 1) && (SUGARcount == 6))
            {
                llSay(0, "/me You added too much yeast.");
                llGiveInventory(_id, KiljuBottle);
            }
            else if (WATERcount < 4)
            {
                llSay(0, "/me You added too little water.");
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
            }
            else if (WATERcount > 4)
            {
                llSay(0, "/me You added too much water.");
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
                llGiveInventory(_id, KiljuBottle);
            }
            else
                llSay(0, "/me Oh no what happened?... this aint gonna work at all...");
            llSetObjectName(origName);
            state default;
        }
        else if(_message == "▼")
            return;
    }
}