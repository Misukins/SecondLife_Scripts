key _id;
key toucher;

integer listenChannel   = -64849782;
integer DEBUG           = FALSE;
integer isEmpty         = FALSE;
integer LidON           = TRUE;
integer YEAST_count     = 1;
integer chan;
integer hand;

string objectname;
string EmptyName        = "Yeast Box (empty)";

list main_buttons       = [];

GiveMenu(key _id)
{
    main_buttons =         [ "Add Yeast", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    llListenRemove(hand);
    chan = llFloor(llFrand(2000000));
    hand = llListen(chan, "", llGetOwner(), "");
    if ( _id == llGetOwner()){
        llDialog(_id, "Yeast Box Menu\nChoose an option!\n"
        + (string)name +"\nYou have "
        + (string)YEAST_count + " Yeast left.\n", main_buttons, chan);
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
            llOwnerSay("Yeast Box is empty!");
        }
        else if((_id != NULL_KEY) && (isEmpty)){
            llSetObjectName(EmptyName);
            llSetPrimitiveParams([PRIM_NAME, EmptyName]);
            llOwnerSay("Yeast Box is empty!");
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
                llOwnerSay("Yeast Box is empty!");
                llDetachFromAvatar();
            }
        }
        else
            llDetachFromAvatar();
    }

    listen(integer _channel, string _name, key _id, string _message)
    {
        if (_channel == listenChannel){
            if (_message == "REFILL_YEAST"){
                if(YEAST_count < 1)
                    YEAST_count += 1;
                else
                    return;
                GiveMenu(_id);
            }
        }
        if (_message == "Add Yeast"){
            if(YEAST_count < 1){
                objectname = llGetObjectName();
                llOwnerSay("Yeast Box is empty!");
                isEmpty = TRUE;
                llSetObjectName(EmptyName);
                llSetPrimitiveParams([PRIM_NAME, EmptyName]);
                llRemoveInventory(llGetScriptName());
                llDetachFromAvatar();
            }
            else{
                YEAST_count -= 1;
                llSay(0, "You added some yeast. :: Total yeast: " + (string)YEAST_count + ".");
                llSay(listenChannel, "Yeast");
                GiveMenu(_id);
            }
            if (DEBUG)
                llOwnerSay("DEBUG :: Channel -64849782: Yeast Sent!");
        }
        else if (_message == "▼")
            return;
    }
}
