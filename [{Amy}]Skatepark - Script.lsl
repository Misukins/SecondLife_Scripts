//!TODO 1. Skate park 2. Bumper cars 3. Skate rink

integer g_chan;
integer g_hand;

list main_buttons =   [ "SkatePark", "BunberCars", "SkateRing", "Close" ];

menu(key id)
{
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llListenRemove( g_chan );
    g_chan = llRound(llFrand(99999)+10);
    g_hand = llListen(g_chan, "", id, "");
    if ( id == llGetOwner())
        llDialog(id, "Hello " + (string)name + " choose your options!", main_buttons, g_chan);
}

default
{
    on_rez( integer _code )
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        if(change & (CHANGED_OWNER | CHANGED_INVENTORY))
            llResetScript();
    }

    attach(key attached)
    {
        if(attached != NULL_KEY)
            llResetScript();
    }

    state_entry()
    {
        llListen (0, "", NULL_KEY, "");
        llAllowInventoryDrop(TRUE);
        llSetText("Rezzer Coming soon....\n((temp mesh o7))", <0.5, 0.0, 0.5>, 1.0);
    }

    touch_start(integer total_number)
    {
        key avatarID = llDetectedKey(0);
        integer avatarGroup = llSameGroup(avatarID);
        if(avatarGroup)
            menu(avatarID);
        else{
            llInstantMessage(avatarID, " <<WRONG GROUP PLEASE CHANGE IT!!! >>");
            return;
        }
            
    }

    listen(integer ch, string name, key id, string msg){
        
    }
}