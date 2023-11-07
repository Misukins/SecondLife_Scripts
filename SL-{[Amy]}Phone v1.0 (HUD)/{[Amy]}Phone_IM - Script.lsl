integer _channel;
integer listen_handle;

list accessList = [];
list main_menu;

CheckMemory(){
    integer free_memory = llGetFreeMemory();
    llOwnerSay((string)free_memory + " bytes of free memory available for allocation.");
}

dumpAccessList(){
    llOwnerSay("current contact list:\n" + llDumpList2String(accessList, ",\n"));
}

ownermenu(key _id){
    main_menu = ["Users", "List", "Reset", "▼"];
    list avatar_name = llParseString2List(llGetDisplayName(_id), [""], []);
    _channel = llFloor(llFrand(2000000));
    listen_handle = llListen(_channel, "", _id, "");
    llDialog(_id, "Hello " + (string)avatar_name + " Select a an option", main_menu, _channel);
}

default
{
    state_entry()
    {
        dumpAccessList();
        CheckMemory();
    }

    touch_start(integer total_number)
    {
        key _id = llGetOwner();
        ownermenu(_id);
    }

    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(listen_handle);
        if (message == "▼")
            return;
        else if (message == "Users")
            state Owner;
        else if (message == "List")
            dumpAccessList();
        else if (message == "Reset")
            llResetScript();
    }
}

state Owner
{
    state_entry()
    {
        llListen(1, "", llGetOwner(), "");
        llOwnerSay("type /1add (username) or if you wish to remove users then type /1del (username), you have 1min (60seconds)!");
        llSetTimerEvent(60);
    }

    listen(integer channel, string name, key id, string message)
    {
        key targetKey;
        if (id == llGetOwner()){
            integer space = llSubStringIndex(message, " ");
            if (space > 0) {
                string command = llGetSubString(message, 0, space - 1);
                string avatar = llGetSubString(message, space + 1, -1);
                targetKey = llName2Key(avatar);
                if (command == "add"){
                    if (llListFindList(accessList, [avatar]) == -1) {
                        accessList = llListInsertList(accessList, [avatar], 0);
                        llOwnerSay("Added: " + avatar + " to contact list");
                        state default;
                    }
                }
                else if (command == "del"){
                    integer pos = llListFindList(accessList, [avatar]);
                    if (pos >= 0) {
                        accessList = llDeleteSubList(accessList, pos, pos);
                        llOwnerSay("Removed: " + avatar + " to contact list");
                        state default;
                    }
                }
            }
        }
    }

    timer()
    {
        llOwnerSay("Users add/delete time expired!");
        state default;
    }
} 
