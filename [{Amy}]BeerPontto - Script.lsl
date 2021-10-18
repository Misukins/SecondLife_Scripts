/*---------- PLEASE DO NOT CHANGE ANYTHING FROM HERE ----------*/
key owner;
key makersID;
key readKey;
key lid_ON_Sound        = "36abc63f-7536-2ee9-efc4-d0fdb98c5767";
key lid_OFF_Sound       = "549679ab-2d75-d3ec-b6e6-76c89a0759e2";
key MakingBeer_Sound  = "62adc742-ccee-3a69-e64b-b70b885a07cf";

string LID_             = "Lid";
// string WATER_                   = "Water";
// string PILSNER_MALT_            = "Pilsner malt";
// string MUNICH_MALT_             = "Munich malt";
// string VIENNA_MALT_             = "Vienna malt";
// string CARAVIENNA_MALT_         = "CaraVienne malt";
// string AROMATIC_MUINCH_         = "Aromatic Munich";
// string TRADITION_PELLET_HOPS_   = "Tradition pellet hops";
// string TETTNANGER_PELLET_HOPS_  = "Tettnanger pellet hops";
// string IRISH_MOSS_              = "Irish moss";
string BeerBottle   = "[{Amy}]Beer Bottle";
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
integer BEERready = FALSE;
integer WATERadded = FALSE;

integer Pilsner_malt_count = 0;
integer Munich_malt_count = 0;
integer Vienna_malt_count = 0;
integer aromatic_Munich_malt_count = 0;
integer CaraVienne_malt_count = 0;
integer Tradition_pellet_hops_count = 0;
integer Tettnanger_pellet_hops_count = 0;
integer Irish_moss_count = 0;
integer WATERcount = 0;

float cookingtime;
float Volume = 1.0;

list main_buttons       = [];
list main_admin_buttons = [];
list mainBeer_buttons  = [];
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
        main_buttons =         [  
                                "Close Lid", "Pilsner", "Munich", "Vienna", "Vienna", "Aromatic", 
                                "CaraVienne", "Tradition", "Tettnanger", "Irish", "Water", "▼" 
                               ];
        main_admin_buttons =   [ 
                                "Close Lid", "Pilsner", "Munich", "Vienna", "Vienna", "Aromatic", 
                                "CaraVienne", "Tradition", "Tettnanger", "Irish", "Water", "▼" 
                               ];
    }
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    if ( _id == llGetOwner()){
        llDialog(_id, (string)owner_name + "'s Beer Making Menu\n
        Current Recipe:\n"
        + (string)Pilsner_malt_count + " Pilsner malt\n"
        + (string)Munich_malt_count + " Munich malt\n"
        + (string)Vienna_malt_count + " Vienna malt\n"
        + (string)aromatic_Munich_malt_count + " Aromatic Munich malt\n"
        + (string)CaraVienne_malt_count + " CaraVienne malt\n"
        + (string)Tradition_pellet_hops_count + " Tradition Pellet hops\n"
        + (string)Tettnanger_pellet_hops_count + " Tettnanger Pellet hops\n"
        + (string)Irish_moss_count + " Irish moss\n"
        + (string)WATERcount + " Water\n
        Choose an option! " + (string)name + "?", main_admin_buttons, chan);
    }
    else{
        llDialog(_id, (string)owner_name + "'s Beer Making Menu\n
        Current Recipe:\n"
        + (string)Pilsner_malt_count + " Pilsner malt\n"
        + (string)Munich_malt_count + " Munich malt\n"
        + (string)Vienna_malt_count + " Vienna malt\n"
        + (string)aromatic_Munich_malt_count + " Aromatic Munich malt\n"
        + (string)CaraVienne_malt_count + " CaraVienne malt\n"
        + (string)Tradition_pellet_hops_count + " Tradition Pellet hops\n"
        + (string)Tettnanger_pellet_hops_count + " Tettnanger Pellet hops\n"
        + (string)Irish_moss_count + " Irish moss\n"
        + (string)WATERcount + " Water\n
        Choose an option! " + (string)name + "?", main_buttons, chan);
    }
}

doBeerRDYMenu(key _id)
{
    if (_id == makersID)
        mainBeer_buttons = [ "Check", "▼" ];
    llListenRemove(hand);
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    llDialog(_id, (string)owner_name + "'s Beer Making Menu\n
    Current Recipe:\n"
        + (string)Pilsner_malt_count + " Pilsner malt\n"
        + (string)Munich_malt_count + " Munich malt\n"
        + (string)Vienna_malt_count + " Vienna malt\n"
        + (string)aromatic_Munich_malt_count + " Aromatic Munich malt\n"
        + (string)CaraVienne_malt_count + " CaraVienne malt\n"
        + (string)Tradition_pellet_hops_count + " Tradition Pellet hops\n"
        + (string)Tettnanger_pellet_hops_count + " Tettnanger Pellet hops\n"
        + (string)Irish_moss_count + " Irish moss\n"
        + (string)WATERcount + " Water\n
    Choose an option! " + (string)name + "?", mainBeer_buttons, chan);
}

init()
{
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    llSetText("", titleColor, 1);
    llSetObjectDesc("");
    determine_bucket_links();
    BEERready = FALSE;
    WATERadded = FALSE;
    Pilsner_malt_count = 0;
    Munich_malt_count = 0;
    Vienna_malt_count = 0;
    aromatic_Munich_malt_count = 0;
    CaraVienne_malt_count = 0;
    Tradition_pellet_hops_count = 0;
    Tettnanger_pellet_hops_count = 0;
    Irish_moss_count = 0;
    WATERcount = 0;
    lidOn();
}

determine_bucket_links()
{
    integer i = link_num;
    integer found = 0;
    do{
        if(llGetLinkName(i) == LID_){
            _lid = i;
            found++;
        }
    }
    while (i-- && found < 1);
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

AddPilsner_malt()
{
    if(Pilsner_malt_count < 7){
        Pilsner_malt_count += 1;
        llSay(0, "You added some Pilsner malt. :: Total: " + (string)Pilsner_malt_count + ".");
    }
    else
        llSay(0, "You tryed to add too much Pilsner malt.");
    Pilsner_malt_count = Pilsner_malt_count++;
}

AddMunich_malt()
{
    if(Munich_malt_count < 7){
        Munich_malt_count += 1;
        llSay(0, "You added some Vienna malt. :: Total: " + (string)Munich_malt_count + ".");
    }
    else
        llSay(0, "You tryed to add too much Vienna malt.");
    Munich_malt_count = Munich_malt_count++;
}

AddVienna_malt()
{
    if(Vienna_malt_count < 6){
        Vienna_malt_count += 1;
        llSay(0, "You added some CaraVienne malt. :: Total: " + (string)Vienna_malt_count + ".");
    }
    else
        llSay(0, "You tryed to add too much CaraVienne malt.");
    Vienna_malt_count = Vienna_malt_count++;
}

Addaromatic_Munich()
{
    if(aromatic_Munich_malt_count < 4){
        aromatic_Munich_malt_count += 1;
        llSay(0, "You added some Aromatic Munich. :: Total: " + (string)aromatic_Munich_malt_count + ".");
    }
    else
        llSay(0, "You tryed to add too much Aromatic Munich.");
    aromatic_Munich_malt_count = aromatic_Munich_malt_count++;
}

AddCaraVienne_malt()
{
    if(CaraVienne_malt_count < 3){
        CaraVienne_malt_count += 1;
        llSay(0, "You added some Tradition pellet hops. :: Total: " + (string)CaraVienne_malt_count + ".");
    }
    else
        llSay(0, "You tryed to add too much Tradition pellet hops.");
    CaraVienne_malt_count = CaraVienne_malt_count++;
}

AddTradition_pellet_hops()
{
    if(Tradition_pellet_hops_count < 4){
        Tradition_pellet_hops_count += 1;
        llSay(0, "You added some Tettnanger pellet hops. :: Total: " + (string)Tradition_pellet_hops_count + ".");
    }
    else
        llSay(0, "You tryed to add too much Tettnanger pellet hops.");
    Tradition_pellet_hops_count = Tradition_pellet_hops_count++;
}

AddTettnanger_pellet_hops()
{
    if(Tettnanger_pellet_hops_count < 4){
        Tettnanger_pellet_hops_count += 1;
        llSay(0, "You added some Tettnanger pellet hops. :: Total: " + (string)Tettnanger_pellet_hops_count + ".");
    }
    else
        llSay(0, "You tryed to add too much Tettnanger pellet hops.");
    Tettnanger_pellet_hops_count = Tettnanger_pellet_hops_count++;
}

AddIrish_moss()
{
    if(Irish_moss_count < 3){
        Irish_moss_count += 1;
        llSay(0, "You added some Irish moss. :: Total: " + (string)Irish_moss_count + ".");
    }
    else
        llSay(0, "You tryed to add too much Irish moss.");
    Irish_moss_count = Irish_moss_count++;
}

addWater()
{
    if(!WATERadded){
        WATERadded = TRUE;
        llSetLinkAlpha(_water, 1, ALL_SIDES);
    }
    if(WATERcount < 6){
        WATERcount += 1;
        llSay(0, "You added some water. :: Total: " + (string)WATERcount + ".");
    }
    else
        llSay(0, "You tryed to add too much water, it would overfill.");
    WATERcount = WATERcount++;
}

dispString(string value)
{
    llSetText(value, titleColor, 1);
}

saveData()
{
    list saveData;
    saveData += (string)Pilsner_malt_count;
    saveData += (string)Munich_malt_count;
    saveData += (string)Vienna_malt_count;
    saveData += (string)aromatic_Munich_malt_count;
    saveData += (string)CaraVienne_malt_count;
    saveData += (string)Tradition_pellet_hops_count;
    saveData += (string)Tettnanger_pellet_hops_count;
    saveData += (string)Irish_moss_count;
    saveData += (string)WATERcount;
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
        (string)Pilsner_malt_count + " Pilsner malt.\n"
        + (string)Munich_malt_count + " Munich malt.\n"
        + (string)Vienna_malt_count + " Vienna malt.\n"
        + (string)aromatic_Munich_malt_count + " Aromatic Munich malt.\n"
        + (string)CaraVienne_malt_count + " CaraVienne malt.\n"
        + (string)Tradition_pellet_hops_count + " Tradition pellet hops.\n"
        + (string)Tettnanger_pellet_hops_count + " Tettnanger pellet hops.\n"
        + (string)Irish_moss_count + " Irish moss.\n"
        + (string)WATERcount + " Water.\n"
        + (string)userName + " (" + makersName + ")\n
        Beer will be ready in:\n" 
        + getTimeString(llRound(cookingtime)));
}

default
{
    state_entry()
    {
        llPreloadSound(lid_ON_Sound);
        llPreloadSound(lid_OFF_Sound);
        llPreloadSound(MakingBeer_Sound);
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
        else if ((_message == "Pilsner") && (!LidON)){
            AddPilsner_malt();
            doMenu(_id);
        }
        else if ((_message == "Munich") && (!LidON)){
            AddMunich_malt();
            doMenu(_id);
        }
        else if ((_message == "Vienna") && (!LidON)){
            AddVienna_malt();
            doMenu(_id);
        }
        else if ((_message == "Aromatic") && (!LidON)){
            Addaromatic_Munich();
            doMenu(_id);
        }
        else if ((_message == "CaraVienne") && (!LidON)){
            AddCaraVienne_malt();
            doMenu(_id);
        }
        else if ((_message == "Tradition") && (!LidON)){
            AddTradition_pellet_hops();
            doMenu(_id);
        }
        else if ((_message == "Tettnanger") && (!LidON)){
            AddTettnanger_pellet_hops();
            doMenu(_id);
        }
        else if ((_message == "Irish") && (!LidON)){
            AddIrish_moss();
            doMenu(_id);
        }
        else if ((_message == "Water") && (!LidON)){
            addWater();
            doMenu(_id);
        }
        else if ((_message == "Finished") && (LidON) && (WATERadded == TRUE)){
            makersID   = _id;
            makersName = llKey2Name(makersID);
            cookingtime = ONE_DAY;
            saveData();
            state MakingBeer;
        }
        else if (_message == "Reset")
            llResetScript();
        else if (_message == "▼")
            return;
    }
}

state MakingBeer
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
        llTriggerSound(MakingBeer_Sound, Volume);
        if (cookingtime <= 0)
            state beerReady;
    }
}

state beerReady
{
    state_entry()
    {
        BEERready = TRUE; //just in case if i add more features with this.
        list userName = llParseString2List(llGetDisplayName(makersID), [""], []);
        llSetText(
            (string)Pilsner_malt_count + " Pilsner malt.\n"
            + (string)Munich_malt_count + " Munich malt.\n"
            + (string)Vienna_malt_count + " Vienna malt.\n"
            + (string)aromatic_Munich_malt_count + " Aromatic Munich malt.\n"
            + (string)CaraVienne_malt_count + " CaraVienne malt.\n"
            + (string)Tradition_pellet_hops_count + " Tradition pellet hops.\n"
            + (string)Tettnanger_pellet_hops_count + " Tettnanger pellet hops.\n"
            + (string)Irish_moss_count + " Irish moss.\n"
            + (string)WATERcount + " Water.\n"
            + (string)userName + " (" + makersName + ")\n
                Beer is ready!", titleColor, 1);
        llGetObjectDesc();
    }

    
    dataserver(key requested, string data)
    {
        list savedList = llParseString2List(llGetObjectDesc(), [","], []);
        if (llGetListLength(savedList) == 12){
            Pilsner_malt_count              = llList2Integer(savedList, 1);
            Munich_malt_count               = llList2Integer(savedList, 2);
            Vienna_malt_count               = llList2Integer(savedList, 3);
            aromatic_Munich_malt_count      = llList2Integer(savedList, 4);
            CaraVienne_malt_count           = llList2Integer(savedList, 5);
            Tradition_pellet_hops_count     = llList2Integer(savedList, 6);
            Tettnanger_pellet_hops_count    = llList2Integer(savedList, 7);
            Irish_moss_count                = llList2Integer(savedList, 8);
            WATERcount                      = llList2Integer(savedList, 9);
            makersID                        = llList2Key(savedList, 10);
            makersName                      = llList2String(savedList, 11);
            cookingtime                     = llList2Integer(savedList, 12);
        }
    }

    touch_start(integer num_detected)
    {
        key _id = llDetectedKey(0);
        list userName = llParseString2List(llGetDisplayName(makersID), [""], []);
        if(_id == makersID)
            doBeerRDYMenu(_id);
        else
            return;
    }

    /*
        Pilsner_malt;   //4
        Munich_malt;    //4
        Vienna_malt;    //5
        aromatic_Munich; //2
        CaraVienne_malt; //1
        Tradition_pellet_hops; //2
        Tettnanger_pellet_hops; //2
        Irish_moss; //1
        _water; //5
    */

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
            if((Pilsner_malt_count == 4) && 
                (Munich_malt_count == 4) && 
                (Vienna_malt_count == 5) && 
                (aromatic_Munich_malt_count == 2) && 
                (CaraVienne_malt_count == 1) && 
                (Tradition_pellet_hops_count == 2) && 
                (Tettnanger_pellet_hops_count == 2) && 
                (Irish_moss_count == 1) && 
                (WATERcount == 5)){
                llSay(0, "/me This is beer you made is verygood shit!");
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
                llGiveInventory(_id, BeerBottle);
            }
            //MORE COMING SOON.....
            else
                llSay(0, "/me Oh no what happened?... this aint gonna work at all...");
            llSetObjectName(origName);
            state default;
        }
        else if(_message == "▼")
            return;
    }
}