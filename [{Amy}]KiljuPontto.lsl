/*
    MORE TO COME BUT BASICKS ARE THERE.
*/


/*---------- PLEASE DO NOT CHANGE ANYTHING FROM HERE ----------*/
key owner;
key lid_ON_Sound        = "36abc63f-7536-2ee9-efc4-d0fdb98c5767";
key lid_OFF_Sound       = "549679ab-2d75-d3ec-b6e6-76c89a0759e2";
key MakinngKilju_Sound  = "62adc742-ccee-3a69-e64b-b70b885a07cf";
key verygoodKilju_Sound   = "eade4b95-0216-6f9f-f65b-d14428ee114d";
/*TODO START--
key goodPatch_Sound      = "";
key badPatch_Sound       = "";
key tooMuchSugar_Sound   = "";
key tooMuchYeast_Sound   = "";
TODO --END */

string LID_        = "Lid";
string WATER_      = "Water";
string YEAST_      = "Yeast";
string SUGAR_      = "Sugar";

integer listenid;
integer chan;
integer hand;
integer link_num;

integer _lid;
integer _water;
integer _yeast;
integer _sugar;

integer LidON = TRUE; // TRUE = 1 / FALSE = 0
integer WATERadded = FALSE;
integer YEASTcount = 0;
integer SUGARcount = 0;

float cookingtime;

list main_buttons       = [];
list main_admin_buttons = [];
/*---------- TO HERE ----------*/

integer DEBUG = TRUE;   //just 4 debug

/*NOTE
    You may change this time.
    float ONE_WEEK = 604800.0; //Week
    float ONE_DAY  = 86400.0;  //Day
    float ONE_HOUR = 3600.0;   //Hour
    float ONE_HHOUR = 1800.0;  //Half an Hours
    float ONE_MINUTE = 60.0;   //Minute
*/
float ONE_DAY  = 86400.0; //Day
float updateInterval = 60.0; //Minute

doMenu(key _id)
{
    if ((LidON) && (WATERadded) && (YEASTcount == 1) && (SUGARcount == 6)){
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
    if ( _id == llGetOwner())
        llDialog(_id, (string)owner_name + "'s Kilju Making Menu\nChoose an option! " + (string)name + "?", main_admin_buttons, chan);
    else
        llDialog(_id, (string)owner_name + "'s Kilju Making Menu\nChoose an option! " + (string)name + "?", main_buttons, chan);
}

init()
{
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    llSetText("", <0.553, 1.000, 0.553>, 1);
    llSetObjectDesc("");
    determine_bucket_links();
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
    llPlaySound(lid_ON_Sound, 1);
    LidON = TRUE;
    if(DEBUG){
        llOwnerSay("lidOn() :: " + (string)LidON + ".");
        printsettings();
    }
}

lidOff()
{
    llSetLinkAlpha(_lid, 0, ALL_SIDES);
    llPlaySound(lid_OFF_Sound, 1);
    LidON = FALSE;
    if(DEBUG){
        llOwnerSay("lidOff() :: " + (string)LidON + ".");
        printsettings();
    }
}

addWater()
{
    if(!WATERadded){
        WATERadded = TRUE;
        llSetLinkAlpha(_water, 1, ALL_SIDES);
    }
    else
        llWhisper(0, "You already added Water.");
    if(DEBUG){
        llOwnerSay("addWater() :: " + (string)WATERadded + ".");
        printsettings();
    }
}

addYeast()
{
    if(YEASTcount == 0){
        llWhisper(0, "You added Yeast.");
        YEASTcount = 1;
        llSetLinkAlpha(_yeast, 1, ALL_SIDES);
    }
    else
        llWhisper(0, "You tryed to add too much Yeast.");
    if(DEBUG){
        llOwnerSay("addYeast() :: " + (string)YEASTcount + ".");
        printsettings();
    }
}

addSugar()
{
    if(SUGARcount < 6){
        llWhisper(0, "You added Sugar.");
        SUGARcount += 1;
        llSetLinkAlpha(_sugar, 1, ALL_SIDES);
    }
    else
        llWhisper(0, "You tryed to add too much Sugar.");
    SUGARcount = SUGARcount++;
}

dispString(string value)
{
    llSetText(value, <0.553, 1.000, 0.553>, 1);
}

saveData()
{
    list saveData;
    saveData += (string)YEASTcount + " Yeast";
    saveData += (string)SUGARcount + " Sugar";
    saveData += (string)llRound(cookingtime) + " Time";
    llSetObjectDesc(llDumpList2String(saveData, "|"));
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
    return (string)days + " day, " + (string)hours + " hours, " + (string)minutes + " minutes";
}

updateTimeDisp()
{
    dispString("\nKilju will be ready in:\n" + getTimeString(llRound(cookingtime)));
}

printsettings() //only shown in DEBUG Mode @ integer DEBUG = TRUE;
{
    llOwnerSay("
    ---SETTINGS---\n"
    + (string)WATERadded + " Water\n"
    + (string)SUGARcount + " Sugar count\n"
    + (string)YEASTcount + " Yeast count\n"
    + (string)LidON + " LID status"
    );
}

default
{
    state_entry()
    {
        init();
        if(DEBUG){
            llOwnerSay("state default");
            printsettings();
        }
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
        else if ((_message == "Finished") && (LidON) && (WATERadded == TRUE) && (YEASTcount == 1) && (SUGARcount == 6)){
            cookingtime = ONE_DAY;
            saveData();
            state MakingKilju;
        }
        else if (_message == "Reset")
            llResetScript();
        else if (_message == "print")
            printsettings();
        else if (_message == "▼")
            return;
    }
}

state MakingKilju
{
    state_entry()
    {
        if(DEBUG){
            llOwnerSay("state MakingKilju");
            printsettings();
        }
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
        saveData();
        updateTimeDisp();
        llTriggerSound(MakinngKilju_Sound, 1);
        if (cookingtime <= 0)
            state KiljuReady;
    }
}

state KiljuReady
{
    state_entry()
    {
        if(DEBUG){
            llOwnerSay("state KiljuReady");
            printsettings();
        }
        llTriggerSound(verygoodKilju_Sound , 1); //for now
        state default; //FIX for new features.... COMING SOON...
        //NOTE more to come!!!!
        /*
        i need to add so you can take Mehukaitti bottles and to those add
        you can drink them and get drunk in SL :D with AO and anims!!! 
        wowweeeeee!!!!
        */
    }
}