/*---------- PLEASE DO NOT CHANGE ANYTHING FROM HERE ----------*/
key owner;
key lid_ON_Sound        = "36abc63f-7536-2ee9-efc4-d0fdb98c5767";
key lid_OFF_Sound       = "549679ab-2d75-d3ec-b6e6-76c89a0759e2";
key MakinngKilju_Sound  = "62adc742-ccee-3a69-e64b-b70b885a07cf";
key verygoodKilju_Sound = "eade4b95-0216-6f9f-f65b-d14428ee114d";
key letsTaste_Sound     = "3f5f7e59-8267-8354-e9b7-3e618f68dfd8";
key yeastShit_Sound     = "48dc19bb-273f-f495-2da0-1bd761bcf8d0";
key yeastOk_Sound       = "6f258eef-6f02-57c7-a837-d3c76af2cdb0";
key sugarShit_Sound     = "2bcd197e-c0fa-b390-6cee-ad8117b59c71";
key sugarOk_Sound       = "4d17f51d-439d-3988-2405-db3e4c8865be";
key drinking_Sound      = "34e7d853-6435-5386-d0c6-c32b316edc90";

string LID_             = "Lid";
string WATER_           = "Water";
string YEAST_           = "Yeast";
string SUGAR_           = "Sugar";
string PENA1_           = "Pena1";
string PENA2_           = "Pena2";
string PENA3_           = "Pena3";
string KiljuBottle      = "Kilju Bottle";
string objectname;

integer listenid;
integer chan;
integer hand;
integer link_num;

integer _lid;
integer _water;
integer _yeast;
integer _sugar;
integer _pena1;
integer _pena2;
integer _pena3;

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
/*---------- TO HERE ----------*/

integer DEBUG = FALSE;   //just 4 debug

/*NOTE
    You may change this time.
    float ONE_WEEK = 604800.0; //Week
    float ONE_DAY  = 86400.0;  //Day
    float ONE_HOUR = 3600.0;   //Hour
    float ONE_HHOUR = 1800.0;  //Half an Hours
    float ONE_MINUTE = 60.0;   //Minute
*/
float ONE_DAY = 86400.0;
float updateInterval = 30.0;

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
        else if(llGetLinkName(i) == PENA1_){
            _pena1 = i;
            found++;
        }
        else if(llGetLinkName(i) == PENA2_){
            _pena2 = i;
            found++;
        }
        else if(llGetLinkName(i) == PENA3_){
            _pena3 = i;
            found++;
        }
    }
    while (i-- && found < 7);
    llSetLinkAlpha(_water, 0, ALL_SIDES);
    llSetLinkAlpha(_yeast, 0, ALL_SIDES);
    llSetLinkAlpha(_sugar, 0, ALL_SIDES);
    llSetLinkAlpha(_pena1, 0, ALL_SIDES);
    llSetLinkAlpha(_pena2, 0, ALL_SIDES);
    llSetLinkAlpha(_pena3, 0, ALL_SIDES);
}

lidOn()
{
    llSetLinkAlpha(_lid, 1, ALL_SIDES);
    llTriggerSound(lid_ON_Sound, Volume);
    LidON = TRUE;
    if(DEBUG){
        llOwnerSay("lidOn() :: " + (string)LidON + ".");
        printsettings();
    }
}

lidOff()
{
    llSetLinkAlpha(_lid, 0, ALL_SIDES);
    llTriggerSound(lid_OFF_Sound, Volume);
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
    if(WATERcount < 6){
        WATERcount += 1;
        llSay(0, "You added some water. :: Total water: " + (string)WATERcount + ".");
    }
    else
        llSay(0, "You tryed to add too much water, it would overfill.");
        WATERcount = WATERcount++;
    if(DEBUG){
        llOwnerSay("addWater() :: " + (string)WATERcount + ".");
        printsettings();
    }
    if(DEBUG){
        llOwnerSay("addWater() :: " + (string)WATERadded + ".");
        printsettings();
    }
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
    if(DEBUG){
        llOwnerSay("addYeast() :: " + (string)YEASTcount + ".");
        printsettings();
    }
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
    if(DEBUG){
        llOwnerSay("addSugar() :: " + (string)SUGARcount + ".");
        printsettings();
    }
}

harvestKilju()
{
    //TODO
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
    saveData += (string)WATERcount + " Water";
    llSetObjectDesc(llDumpList2String(saveData, ", "));
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
        llPreloadSound(lid_ON_Sound);
        llPreloadSound(lid_OFF_Sound);
        llPreloadSound(MakinngKilju_Sound);
        llPreloadSound(verygoodKilju_Sound);
        llPreloadSound(letsTaste_Sound);
        llPreloadSound(yeastShit_Sound);
        llPreloadSound(yeastOk_Sound);
        llPreloadSound(sugarShit_Sound);
        llPreloadSound(sugarOk_Sound);
        llPreloadSound(drinking_Sound);
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
        else if ((_message == "Finished") && (LidON) && (WATERadded == TRUE)){
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
            llOwnerSay("state MakingKilju " + llGetObjectDesc());
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
        llTriggerSound(MakinngKilju_Sound, Volume);
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
        KILJUReady = TRUE; //just in case if i add more features with this.
        llSetText("Kilju is ready to drink!", <0.553, 1.000, 0.553>, 1);
        llGetObjectDesc();
        llSetLinkAlpha(_pena1, 1, ALL_SIDES);
        llSetLinkAlpha(_pena2, 1, ALL_SIDES);
        llSetLinkAlpha(_pena3, 1, ALL_SIDES);
         //for now
        //state default; //FIX for new features.... COMING SOON...
        //NOTE more to come!!!!
        /*
        i need to add so you can take Mehukaitti bottles and to those add
        you can drink them and get drunk in SL :D with AO and anims!!! 
        wowweeeeee!!!!
        */
    }

    touch_start(integer num_detected)
    {
        key _id = llDetectedKey(0);
        lidOff();
        string origName = llGetObjectName();
        llSetObjectName("Pena");
        llTriggerSound(letsTaste_Sound, Volume);
        llSay(0, "Let me taste it..");
        llSleep(8.0);
        llTriggerSound(drinking_Sound, Volume);
        llSay(0, "*drinks*");
        llSleep(10.0);
        if((WATERcount == 4) && (YEASTcount == 1) && (SUGARcount == 6)){
            llTriggerSound(verygoodKilju_Sound, Volume);
            llSay(0, "This is VeryGood shit!");
            llGiveInventory(_id, KiljuBottle);
            llGiveInventory(_id, KiljuBottle);
            llGiveInventory(_id, KiljuBottle);
            llGiveInventory(_id, KiljuBottle);
            llGiveInventory(_id, KiljuBottle);
            llGiveInventory(_id, KiljuBottle);
        }
        else if ((YEASTcount == 1) && (SUGARcount < 6))
        {
            llTriggerSound(yeastOk_Sound, Volume);
            llSleep(10.0);
            llTriggerSound(sugarShit_Sound, Volume);
            llSay(0, "You added too much Sugar... im gonna puke!");
            llGiveInventory(_id, KiljuBottle);
            llGiveInventory(_id, KiljuBottle);
            llGiveInventory(_id, KiljuBottle);
        }
        else if ((YEASTcount > 1) && (SUGARcount == 6))
        {
            llTriggerSound(yeastShit_Sound, Volume);
            llSleep(10.0);
            llTriggerSound(sugarOk_Sound, Volume);
            llSay(0, "You added too much Yeast... tastes like vinegar!");
            llGiveInventory(_id, KiljuBottle);
        }
        else
        {
            llTriggerSound(yeastShit_Sound, Volume);
            llSleep(10.0);
            llTriggerSound(sugarShit_Sound, Volume);
            llSay(0, "Oh no what happened?... this tastes like shit.. more Sugar and less Yeast maybe?");
        }
        llSetObjectName(origName);
        state default;
    }
}