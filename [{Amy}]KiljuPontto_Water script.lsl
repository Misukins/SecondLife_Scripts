key _id;
integer _chan           = -64849782;
integer chan;
integer hand;
integer DEBUG           = FALSE;

list main_buttons       = [];
list main_admin_buttons = [];

GiveMenu(key _id)
{
    main_buttons =         [ "Add Water", "▼" ];
    main_admin_buttons =   [ "Add Water", "Reset", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", llGetOwner(), "");
    if ( _id == llGetOwner())
        llDialog(_id, "Water Box Menu\nChoose an option! " + (string)name + "?", main_admin_buttons, chan);
    else
        llDialog(_id, "Water Box Menu\nChoose an option! " + (string)name + "?", main_buttons, chan);
}

default
{
    state_entry()
    {
        //NADA!
    }
    
    attach(key attached)
    {
        _id = llGetOwner();
        if(attached != NULL_KEY)
        {
            if (DEBUG == TRUE)
                llOwnerSay("DEBUG :: Channel -64849782: Attached!");
            GiveMenu(_id);
        }
    }

    /* FAIL SAFE FOR THE LAG*/
    touch_start(integer total_number)
    {
        key _id = llGetOwner();
        GiveMenu(_id);
    }

    listen(integer _channel, string _name, key _id, string _message)
    {
        if (_message == "Add Water"){
            llSay(_chan, "Water");
            GiveMenu(_id);
            if (DEBUG == TRUE)
                llOwnerSay("DEBUG :: Channel -64849782: Water Sent!");
        } 
        else if (_message == "Reset"){
            llInstantMessage(_id, "..Resetting..");
            llResetScript();
        }
        else if (_message == "▼")
            return;
    }
}
