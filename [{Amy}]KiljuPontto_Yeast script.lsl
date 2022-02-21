/*
TODO 
Amy: countdown from 5 uses then its empty?

Kenzi: Now it's one time use.. its way too fast lol so FIX it bitch ASAP!
Kenzi: Add safety net when rezzed.. just delete it or do NO-COPY

Amy: ok so NO-MOD NO-COPY ok
*/

key _id;
key toucher;

integer _chan           = -64849782;
integer chan;
integer hand;
integer DEBUG           = FALSE;
integer isEmpty         = FALSE;
integer YEAST_count     = 5;

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
    llListen(_chan, "", "", "");
    GiveMenu(_id);   
}

default
{
    state_entry()
    {
        //NADA
    }

    attach(key _id)
    {
        if((_id != NULL_KEY) && (isEmpty)){
            llSetObjectName(EmptyName);
            llSetPrimitiveParams([PRIM_NAME, EmptyName]);
            llOwnerSay("Yeast Box is empty!");
            llDetachFromAvatar();
            llDie();
        }
        else if ((_id != NULL_KEY) && (!isEmpty)){
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
            Init(_id);
            if (DEBUG)
                llOwnerSay("DEBUG :: Channel -64849782: Attached!");
        }
    }

    /* FAIL SAFE FOR THE LAG*/
    touch_start(integer total_number)
    {
        _id = llGetOwner();
        toucher = llDetectedKey(0);
        if(_id == toucher)
            GiveMenu(_id);
        else
            return;
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
                llDie();
            }
        }
        else{
            llDetachFromAvatar();
            llDie();
        }
    }

    listen(integer _channel, string _name, key _id, string _message)
    {
        if (_channel == _chan){
            if (_message == "REFILL_YEAST"){
                if(YEAST_count < 5)
                    YEAST_count += 1;
                else
                    return;
                GiveMenu(_id);
            }
        }
        if (_message == "Add Yeast"){
            if(YEAST_count == 0){
                objectname = llGetObjectName();
                llOwnerSay("Yeast Box is empty!");
                isEmpty = TRUE;
                llSetObjectName(EmptyName);
                llSetPrimitiveParams([PRIM_NAME, EmptyName]);
                llDetachFromAvatar();
                llDie();
            }
            else{
                YEAST_count -= 1;
                llSay(0, "You added some yeast. :: Total yeast: " + (string)YEAST_count + ".");
                llSay(_chan, "Yeast");
                GiveMenu(_id);
            }
            if (DEBUG)
                llOwnerSay("DEBUG :: Channel -64849782: Yeast Sent!");
        }
        else if (_message == "▼")
            return;
    }
}
