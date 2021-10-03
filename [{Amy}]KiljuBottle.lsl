/*
    THIS WILL CHANGE ON THE ROAD:: JUST A TEST VERSION TO SEE IF IT WORKS
*/

key owner;

string CAP_        = "Cap";

integer _cap;
integer capON = TRUE;

integer listenid;
integer chan;
integer hand;
integer link_num;

list main_buttons       = [];
list main_admin_buttons = [];

doMenu(key _id)
{
    if(capON){
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
    owner = llGetOwner();
    link_num = llGetNumberOfPrims();
    determine_bucket_links();
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

capOn()
{
    llSetLinkAlpha(_cap, 1, ALL_SIDES);
    capON = TRUE;
}

capOff()
{
    llSetLinkAlpha(_cap, 0, ALL_SIDES);
    capON = FALSE;
}

default
{
    state_entry()
    {
        init();
    }

    touch_start(integer total_number)
    {
        key _id = llDetectedKey(0);
        doMenu(_id);
    }
    
    listen(integer _channel, string _name, key _id, string _message)
    {
        if (_message == "Open Cap"){
            capOff();
            doMenu(_id);
        }
        else if (_message == "Close Cap"){
            capOn();
            doMenu(_id);
        }
        else if (_message == "Reset")
            llResetScript();
        else if (_message == "▼")
            return;
    }
}
