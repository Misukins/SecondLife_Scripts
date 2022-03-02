key _id;
key toucher;

integer listenChannel   = -64849782;
integer DEBUG           = FALSE;
integer isEmpty         = FALSE;
integer LidON           = TRUE;
integer SUGAR_count     = 10;
integer chan;
integer hand;

string objectname;
string EmptyName        = "Sugar bag (empty)";

list main_buttons       = [];

GiveMenu(key _id)
{
    main_buttons =         [ "Add Sugar", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", llGetOwner(), "");
    if ( _id == llGetOwner()){
        llDialog(_id, "Sugar bag Menu\nChoose an option!\n"
        + (string)name +"\nYou have "
        + (string)SUGAR_count + " Sugar left.\n", main_buttons, chan);
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
            llOwnerSay("Sugar bag is empty!");
        }
        else if((_id != NULL_KEY) && (isEmpty)){
            llSetObjectName(EmptyName);
            llSetPrimitiveParams([PRIM_NAME, EmptyName]);
            llOwnerSay("Sugar bag is empty!");
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
                llOwnerSay("Sugar bag is empty!");
                llDetachFromAvatar();
            }
        }
        else
            llDetachFromAvatar();
    }

    listen(integer _channel, string _name, key _id, string _message)
    {
        if (_channel == listenChannel){
            if (_message == "REFILL_SUGAR"){
                if(SUGAR_count < 10)
                    SUGAR_count += 1;
                else
                    return;
                GiveMenu(_id);
            }
        }
        if (_message == "Add Sugar"){
            if(SUGAR_count < 1){
                objectname = llGetObjectName();
                llOwnerSay("Sugar bag is empty!");
                isEmpty = TRUE;
                llSetObjectName(EmptyName);
                llSetPrimitiveParams([PRIM_NAME, EmptyName]);
                llRemoveInventory(llGetScriptName());
                llDetachFromAvatar();
            }
            else{
                SUGAR_count -= 1;
                llSay(0, "You added some Sugar. :: Total Sugar: " + (string)SUGAR_count + ".");
                llSay(listenChannel, "Sugar");
                GiveMenu(_id);
            }
            if (DEBUG)
                llOwnerSay("DEBUG :: Channel -64849782: Sugar Sent!");
        }
        else if (_message == "▼")
            return;
    }
}
