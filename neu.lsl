float pushPower = 5.0;
list accessList = [];

dumpAccessList()
{
    llOwnerSay("current access list: " + llDumpList2String(accessList, ", "));
}

default
{
    state_entry()
    {
        llListen(1, "", NULL_KEY, "");
        accessList = [];
    }

    collision_start(integer detected) 
    {
        key ownerKey = llGetOwner();
        key detectedKey = llDetectedKey(0);
        string owner = llKey2Name(ownerKey);
        string avatar = llKey2Name(detectedKey);
        if (llListFindList(accessList, [avatar]) < 0 && detectedKey != ownerKey) {
            llWhisper(0, "you are not on the access list, ask " + owner + " if you would like to visit this place");
            vector vel = -llDetectedVel(0);
            llPushObject(llDetectedKey(0), pushPower * vel, ZERO_VECTOR, FALSE);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (id == llGetOwner()) {
            integer space = llSubStringIndex(message, " ");
            if (space > 0) {
                string command = llGetSubString(message, 0, space - 1);
                string avatar = llGetSubString(message, space + 1, -1);
                if (command == "add"){
                    if (llListFindList(accessList, [avatar]) == -1) {
                        accessList = llListInsertList(accessList, [avatar], 0);
                    }

                }
                else if (command == "del"){
                    integer pos = llListFindList(accessList, [avatar]);
                    if (pos >= 0) {
                        accessList = llDeleteSubList(accessList, pos, pos);
                        dumpAccessList();
                    }
                }
                dumpAccessList();
            }
        }
    }

    touch_start(integer total_number)
    {
        key ownerKey = llGetOwner();
        key detectedKey = llDetectedKey(0);
        if (detectedKey == ownerKey) {
            dumpAccessList();
        }
    }
}