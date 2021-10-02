key owner;

key lid_ON_Sound        = "36abc63f-7536-2ee9-efc4-d0fdb98c5767";
key lid_OFF_Sound       = "549679ab-2d75-d3ec-b6e6-76c89a0759e2";
key MakinngKilju_Sound  = "62adc742-ccee-3a69-e64b-b70b885a07cf";
/*TODO START--
//Sounds
string perfectPatch_Sound   = "";
string goodPatch_Sound      = "";
string badPatch_Sound       = "";
string tooMuchSugar_Sound   = "";
string tooMuchYeast_Sound   = "";
TODO --END */

string LID_        = "Lid";
string WATERLOCK_  = "waterLock";
string WATER_      = "Water";
string YEAST_      = "Yeast";

integer listenid;
integer chan;
integer hand;
integer link_num;

integer _lid;
integer _water;
integer _yeast;
integer _waterlock;

integer LidON = TRUE;

list main_buttons       = [];
list main_admin_buttons = [];

doMenu(key _id)
{
    if(LidON){
        main_buttons =         [ "Open Lid", "▼" ];
        main_admin_buttons =   [ "Open Lid", "Reset", "▼" ];
    }
    else{
        main_buttons =         [ "Close Lid", "add Water", "add Yeast", "add Sugar", "▼" ];
        main_admin_buttons =   [ "Close Lid", "add Water", "add Yeast", "add Sugar", "Reset", "▼" ];
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

info(string message)
{
    llOwnerSay("[INFO] " + message);
}

init()
{
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    llPreloadSound(lid_ON_Sound);
    llPreloadSound(lid_OFF_Sound);
    llPreloadSound(MakinngKilju_Sound);
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
        else if(llGetLinkName(i) == WATERLOCK_){
            _waterlock = i;
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
    }
    while (i-- && found < 4);
}

lidOn()
{
    llSetLinkAlpha(_lid, 1, ALL_SIDES);
    llSetLinkAlpha(_waterlock, 1, ALL_SIDES);
    llPlaySound(lid_ON_Sound, 1);
    LidON = TRUE;
}

lidOff()
{
    llSetLinkAlpha(_lid, 0, ALL_SIDES);
    llSetLinkAlpha(_waterlock, 0, ALL_SIDES);
    llPlaySound(lid_OFF_Sound, 1);
    LidON = FALSE;
}

addWater()
{
    //TODO
}

addYeast()
{
    //TODO
}

addSugar()
{
    //TODO
}

default
{
    state_entry()
    {
        init();
    }

    on_rez(integer num)
    {
        llResetScript();
    }

    changed(integer change)
    {
        //
    }

    touch_start(integer total_number)
    {
        key _id = llDetectedKey(0);
        doMenu(_id);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "Open Lid"){
            lidOff();
        }
        else if (message == "Close Lid"){
            lidOn();
        }
        else if ((message == "add Water") && (LidON))
        {
            addWater();
        }
        else if ((message == "add Yeast") && (LidON))
        {
            addYeast();
        }
        else if ((message == "add Sugar") && (LidON))
        {
            addSugar();
        }
        else if (message == "Reset")
            llResetScript();
        else if (message == "▼")
            return;
    }

    timer()
    {
        //
    }
}