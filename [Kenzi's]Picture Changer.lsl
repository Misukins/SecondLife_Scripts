key BLANK                   = "b89a61a3-4c72-f408-7dc8-026ef5cb3480";

string  confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string  accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";

integer Group_Only      = FALSE;
integer Owner_Only      = TRUE;
integer Public_Access   = FALSE;

integer TVOn            = FALSE;

integer random          = TRUE;
integer duplicatecheck  = TRUE;

integer DISPLAY_ON_SIDE = 3;

integer numberoftextures;
integer current_texture;
integer primslength;

integer _channel_       = 66;
integer listenid;

integer chan;
integer hand;

float time              = 30.0;

list main_buttons       = [];
list main_admin_buttons = [];
list AccessList_Menu    = [];

list prims = [1];

doAccessListMenu(key _id)
{
    llListenRemove(hand);
    list AccessList_Menu =          [ "Group", "Private", "Public", "◄", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    llDialog(_id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", AccessList_Menu, chan);
}

doMenu(key _id)
{
    if(TVOn){
        main_buttons =         [ "Close TV", "▼" ];
        main_admin_buttons =   [ "Close TV", "Access", "Reset", "▼" ];
    }
    else{
        main_buttons =         [ "Open TV", "▼" ];
        main_admin_buttons =   [ "Open TV", "Access", "Reset", "▼" ];
    }
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", _id, "");
    if ( _id == llGetOwner())
        llDialog(_id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", main_admin_buttons, chan);
    else
        llDialog(_id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", main_buttons, chan);
}

pictures()
{
    integer counter;
    string texture = llGetInventoryName(INVENTORY_TEXTURE, current_texture);
    do
    {
        llSetLinkTexture(llList2Integer(prims,counter), texture, DISPLAY_ON_SIDE);
        display_texture(current_texture);
    }
    while(++counter < primslength);
}

display_texture(integer check)
{
    string name = llGetInventoryName(INVENTORY_TEXTURE, current_texture);
    llSetObjectDesc("Showing Picture: " + name + " (" + (string)current_texture + "/" + (string)numberoftextures + ")");
    //llSetText("Showing Picture:\n" + name + " (" + (string)current_texture + "/" + (string)numberoftextures + ")", <1.0, 1.0, 1.0>, 1.0);
}

default
{
    state_entry()
    {
        numberoftextures = llGetInventoryNumber(INVENTORY_TEXTURE);
        primslength = llGetListLength(prims);
        llAllowInventoryDrop(TRUE);
        if(numberoftextures <= 0)
            llSay(0, "No textures were found in my inventory. Please add textures.");
        else if(numberoftextures == 1)
            llSay(0, "I only found 1 picture in my inventory. I need more in order to change them.");
        else
        {
            llSay(0, "I found " + (string)numberoftextures + " pictures which I will change every " + (string)time + " seconds on these prims: " + llList2CSV(prims) + ".");
            llSetTimerEvent(time);
        }
    }

    on_rez(integer num)
    {
        llResetScript();
    }
    
    touch_start(integer total_number)
    {
        key _id = llDetectedKey(0);
        key owner = llGetOwner();
        integer sameGroup = llSameGroup(_id);
        if (Group_Only == TRUE){
            if (sameGroup || _id == owner)
                doMenu(_id);
            else{
                llWhisper(0, "Access Denied!");
                llTriggerSound(accessDeniedSound, 1.0);
            }
        }
        else if (Owner_Only == TRUE){
            if(_id == owner)
                doMenu(_id);
            else{
                llWhisper(0, "Access Denied!");
                llTriggerSound(accessDeniedSound, 1.0);
            }
        }
        else if (Public_Access == TRUE)
            doMenu(_id);
    }

    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
            llResetScript();
    }
    
    listen(integer _chan, string n, key _id, string _message)
    {
        if(_chan != chan){
            llSetPrimMediaParams(DISPLAY_ON_SIDE, [
                PRIM_MEDIA_ALT_IMAGE_ENABLE, TRUE, 
                PRIM_MEDIA_CURRENT_URL, _message, 
                PRIM_MEDIA_CONTROLS, 0, 
                PRIM_MEDIA_AUTO_PLAY, TRUE,
                PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
                PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_ANYONE
            ]);
            llSay(0, "Connecting...\n" + (string)_message + "\nPlase wait...");
            llSetText("", <1.0, 1.0, 1.0>, 1.0);
            llSetTimerEvent(0);
        }
        if(_chan == chan){
            if(_message == "Open TV"){
                llSay(0, "Please type: /" + (string)_channel_ + "URL (Youtube video id or namy URL)\nPlease type: /" + (string)_channel_ + "tvoff to turn TV Off");
                listenid = llListen(_channel_, "", "","");
                TVOn = TRUE;
            }
            else if(_message == "Close TV"){
                llSetPrimMediaParams(DISPLAY_ON_SIDE, [
                    PRIM_MEDIA_ALT_IMAGE_ENABLE, FALSE, 
                    PRIM_MEDIA_CURRENT_URL, "", 
                    PRIM_MEDIA_CONTROLS, 0, 
                    PRIM_MEDIA_AUTO_PLAY, FALSE,
                    PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
                    PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_ANYONE
                ]);
                llSay(0, "Turning TV off...");
                llListenRemove(listenid);
                pictures();
                display_texture(current_texture);
                llSetTimerEvent(time);
                TVOn = FALSE;
            }
            else if(_message == "Access"){
                if (_id == llGetOwner())
                    doAccessListMenu(_id);
                else
                    return;
            }
            else if (_message == "Group"){
                Group_Only      = TRUE;
                Owner_Only      = FALSE;
                Public_Access   = FALSE;
                llWhisper(0, "Group mode has been set!");
            }
            else if (_message == "Private"){
                Group_Only      = FALSE;
                Owner_Only      = TRUE;
                Public_Access   = FALSE;
                llWhisper(0, "Private mode has been set!");
            }
            else if (_message == "Public"){
                Group_Only      = FALSE;
                Owner_Only      = FALSE;
                Public_Access   = TRUE;
                llWhisper(0, "Public mode has been set!");
            }
            else if(_message == "◄")
                doMenu(_id);
            else if(_message == "Reset")
                llResetScript();
            else if(_message == "▼")
                return;
        }
    }

    timer()
    {
        if(random){
            integer randomtexture;
            if(duplicatecheck){
                do{
                    randomtexture= llRound(llFrand(numberoftextures - 1));
                }
                while(randomtexture == current_texture);
            }
            else
                randomtexture = llRound(llFrand(numberoftextures - 1));
            current_texture = randomtexture;
            pictures();
        }
        else
        {
            ++current_texture;
            if(current_texture == numberoftextures)
                current_texture = 0;
            pictures();
        }
        llSetTimerEvent(time);
    }    
}