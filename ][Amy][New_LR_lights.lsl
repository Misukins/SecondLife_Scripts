float soundVolume           = 1.0;

integer Group_Only          = FALSE;
integer Owner_Only          = FALSE;
integer Public_Access       = TRUE;
integer On                  = FALSE;
integer LIGHT_SIDE          = 3;

integer LINKLIGHTS1         = 4;
integer LINKLIGHTS2         = 7;

integer channel;
integer listener;

list AccessList_Menu        = ["Group", "Private", "Public", "Back", "Exit"];

string  accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";

doMenu(key id){
    if (On == FALSE){
        list main_menu = [ "□ On", "Access", "Exit" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
    else if (On == TRUE){
        list main_menu = [ "■ On", "Access", "Exit" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
}

doAccessListMenu(key id){
    llListenRemove(listener);
    channel = llFloor(llFrand(2000000));
    listener = llListen(channel, "", id, "");
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    llDialog(id, "Hey " + (string)name + ".\nPlease select your option:", AccessList_Menu, channel);
}

DeniedSound(){
    llWhisper(0, "Access Denied!");
    llTriggerSound(accessDeniedSound, soundVolume);
}

lightsON(){
    On = TRUE;

    llSetLinkPrimitiveParamsFast(LINKLIGHTS1, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(LINKLIGHTS1, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(LINKLIGHTS1, [PRIM_GLOW,LIGHT_SIDE,0.25]);

    llSetLinkPrimitiveParamsFast(LINKLIGHTS2, [PRIM_FULLBRIGHT,LIGHT_SIDE,TRUE]);
    llSetLinkPrimitiveParamsFast(LINKLIGHTS2, [PRIM_POINT_LIGHT,TRUE,<1.000, 0.867, 0.733>, 0.600, 4.0, 0.550 ]);
    llSetLinkPrimitiveParamsFast(LINKLIGHTS2, [PRIM_GLOW,LIGHT_SIDE,0.25]);
}

lightsOFF(){
    On = FALSE;

    llSetLinkPrimitiveParamsFast(LINKLIGHTS1, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(LINKLIGHTS2, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(LINKLIGHTS1, [PRIM_GLOW,LIGHT_SIDE,0.0]);

    llSetLinkPrimitiveParamsFast(LINKLIGHTS2, [PRIM_FULLBRIGHT,LIGHT_SIDE,FALSE]);
    llSetLinkPrimitiveParamsFast(LINKLIGHTS2, [PRIM_POINT_LIGHT, FALSE,<1.000, 0.867, 0.733>, 0.200, 4.0, 1.0 ]);
    llSetLinkPrimitiveParamsFast(LINKLIGHTS2, [PRIM_GLOW,LIGHT_SIDE,0.0]);
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        lightsOFF();
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        key owner = llGetOwner();
        integer sameGroup = llSameGroup(id);
        if (Group_Only == TRUE){
            if (sameGroup || id == owner)
                doMenu(id);
            else
                DeniedSound();
        }
        else if (Owner_Only == TRUE){
            if(id == owner)
                doMenu(id);
            else
                DeniedSound();
        }
        else if (Public_Access == TRUE)
            doMenu(id);
    }

    listen(integer chan, string name, key id, string msg)
    {
        if (msg == "Exit")
            return;
        else if (msg == "Back")
            doMenu(id);
        else if (msg == "Access"){
            if (id == llGetOwner())
                doAccessListMenu(id);
            else
                return;
        }
        else if (_message == "Group"){
            Group_Only      = TRUE;
            Owner_Only      = FALSE;
            Public_Access   = FALSE;
            llWhisper(0, "Group mode has been set!");
            return;
        }
        else if (_message == "Private"){
            Group_Only      = FALSE;
            Owner_Only      = TRUE;
            Public_Access   = FALSE;
            llWhisper(0, "Private mode has been set!");
            return;
        }
        else if (_message == "Public"){
            Group_Only      = FALSE;
            Owner_Only      = FALSE;
            Public_Access   = TRUE;
            llWhisper(0, "Public mode has been set!");
            return;
        }
        else if (msg == "□ On")
            lightsON();
        else if (msg == "■ On")
            lightsOFF();
        else
            return;
    }
}