key _id;
key toucher;

integer listenChannel   = -64849782;
integer DEBUG           = FALSE;
integer isEmpty         = FALSE;
integer LidON           = TRUE;
integer WATER_count     = 4;
integer chan;
integer hand;

string objectname;
string EmptyName        = "Water jug (empty)";

list main_buttons       = [];

GiveMenu(key _id)
{
    main_buttons =         [ "Add Water", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", llGetOwner(), "");
    if ( _id == llGetOwner()){
        llDialog(_id, "Water jug Menu\nChoose an option!\n"
        + (string)name +"\nYou have "
        + (string)WATER_count + " Water left.\n", main_buttons, chan);
    }
}

Init(key _id)
{
    llListen(listenChannel, "", "", "");
    GiveMenu(_id);   
}

default
{
    attach(key _id)
    {
        if((_id == NULL_KEY) && (!isEmpty))
            llSay(listenChannel, "isNotOpen");
        else if((_id == NULL_KEY) && (isEmpty)){
            llSay(listenChannel, "isNotOpen");
            llSetObjectName(EmptyName);
            llSetPrimitiveParams([PRIM_NAME, EmptyName]);
            llOwnerSay("Water jug is empty!");
        }
        else if((_id != NULL_KEY) && (isEmpty)){
            llSetObjectName(EmptyName);
            llSetPrimitiveParams([PRIM_NAME, EmptyName]);
            llOwnerSay("Water jug is empty!");
            llSay(listenChannel, "isNotOpen");
            llDetachFromAvatar();
        }
        else if ((_id != NULL_KEY) && (!isEmpty)){
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
            Init(_id);
            llSay(listenChannel, "isOpen");
            if (DEBUG)
                llOwnerSay("DEBUG :: Channel -64849782: Attached!");
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_ATTACH){
            llAttachToAvatar(ATTACH_RHAND);
            if(isEmpty){
                llSetObjectName(EmptyName);
                llSetPrimitiveParams([PRIM_NAME, EmptyName]);
                llOwnerSay("Water jug is empty!");
                llDetachFromAvatar();
            }
        }
        else
            llDetachFromAvatar();
    }

    listen(integer _channel, string _name, key _id, string _message)
    {
        if (_channel == listenChannel){
            if (_message == "REFILL_WATER"){
                if(WATER_count < 4)
                    WATER_count += 1;
                else
                    return;
                GiveMenu(_id);
            }
        }
        if (_message == "Add Water"){
            if(WATER_count < 1){
                objectname = llGetObjectName();
                llOwnerSay("Water jug is empty!");
                isEmpty = TRUE;
                llSetObjectName(EmptyName);
                llSetPrimitiveParams([PRIM_NAME, EmptyName]);
                llRemoveInventory(llGetScriptName());
                llDetachFromAvatar();
            }
            else{
                WATER_count -= 1;
                llSay(0, "You added some Water. :: Total Water: " + (string)WATER_count + ".");
                llSay(listenChannel, "Water");
                GiveMenu(_id);
            }
            if (DEBUG)
                llOwnerSay("DEBUG :: Channel -64849782: Water Sent!");
        }
        else if (_message == "▼")
            return;
    }
}
