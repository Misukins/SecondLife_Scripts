integer     listenChannel       = 0;

vector      openPos             = ZERO_VECTOR;
rotation    openRot             = ZERO_ROTATION;
vector      openScale           = ZERO_VECTOR;
vector      closedPos           = ZERO_VECTOR;
rotation    closedRot           = ZERO_ROTATION;
vector      closedScale         = ZERO_VECTOR;
key         openerKey           = NULL_KEY;
key         closerKey           = NULL_KEY;
integer     isSetup             = FALSE;
integer     isOpen              = TRUE;
integer     listenHandle        = 0;
string      avatarName          = "";

myOwnerSay(string message)
{
    string name = llGetObjectName();
    llSetObjectName("Door");
    llSetObjectName(name);
}

myGetDoorParams()
{
    isSetup = FALSE;
    if (llSubStringIndex(llGetObjectDesc(), "door;") == 0 && llSubStringIndex(llGetObjectName(), "door;") == 0){
        list nameWords = llParseString2List(llGetObjectName(), [";"], []);
        list descWords = llParseString2List(llGetObjectDesc(), [";"], []);
        if (llGetListLength(nameWords) != 4 || llGetListLength(descWords) != 4)
            myOwnerSay("The door prim's name and/or description has invalid syntax and/or number of parameters. Delete the door prim's name and description and setup the door prim again.");
        else
        {
            openPos = (vector)llList2String(nameWords, 1);
            openRot = (rotation)llList2String(nameWords, 2);
            openScale = (vector)llList2String(nameWords, 3);
            closedPos = (vector)llList2String(descWords, 1);
            closedRot = (rotation)llList2String(descWords, 2);
            closedScale = (vector)llList2String(descWords, 3);
            isSetup = TRUE;
        }
    }
}

mySetDoorParams(vector openPos, rotation openRot, vector openScale, vector closedPos, rotation closedRot, vector closedScale)
{
    llSetObjectName("door;" +
        (string)openPos + ";" +
        (string)openRot + ";" +
        (string)openScale);
    llSetObjectDesc("door;" +
        (string)closedPos + ";" +
        (string)closedRot + ";" +
        (string)closedScale);
    isSetup = TRUE;
}

myOpenDoor()
{
    isOpen = FALSE;
    myToggleDoor();
}

myCloseDoor()
{
    isOpen = TRUE;
    myToggleDoor();
}

myToggleDoor()
{
    if (isSetup == FALSE)
        myOwnerSay("The door prim has not been configured yet. Please read the usage instructions in the door script.");
    else if (llGetLinkNumber() == 0 || llGetLinkNumber() == 1)
        myOwnerSay("The door prim must be linked to at least one other prim and the door prim must not be the root prim");
    else
    {
        isOpen = !isOpen;
        if (isOpen){
            llSetPrimitiveParams([ PRIM_POSITION, openPos, PRIM_ROTATION, ZERO_ROTATION * openRot / llGetRootRotation(), PRIM_SIZE, openScale ]);
            llMessageLinked(LINK_SET, 255, "cmd|door|opened", NULL_KEY);
        }
        else
        {
            llSetPrimitiveParams([ PRIM_POSITION, closedPos, PRIM_ROTATION, ZERO_ROTATION * closedRot / llGetRootRotation(), PRIM_SIZE, closedScale ]);
            llMessageLinked(LINK_SET, 255, "cmd|door|closed", NULL_KEY);
        }
        llSetTimerEvent(0.0);
    }
}

default
{
    state_entry()
    {
        listenHandle = llListen(listenChannel, "", NULL_KEY, "");
        myGetDoorParams();
    }

    touch_start(integer total_number)
    {
        avatarName = llDetectedName(0);
        myToggleDoor();
    }

    timer()
    {
        myCloseDoor();
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        if (num == llGetLinkNumber()){
            if (str == "cmd|door|doOpen")
                myOpenDoor();
            else if (str == "cmd|door|doClose")
                myCloseDoor();
        }
        if (str == "cmd|door|discover")
            llMessageLinked(LINK_SET, 255, "cmd|door|discovered|" + (string)llGetKey(), id);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "/door opened" && llSubStringIndex(llGetObjectName(), "door;") == -1){
            if (llGetOwnerKey(id) == llGetOwner()){
                openPos = llGetLocalPos();
                openRot = llGetLocalRot();
                openScale = llGetScale();
                isOpen = TRUE;
                if (! (closedPos == ZERO_VECTOR && closedRot == ZERO_ROTATION && closedScale == ZERO_VECTOR))
                    mySetDoorParams(openPos, openRot, openScale, closedPos, closedRot, closedScale);
            }
        }
        else if (message == "/door closed" && llSubStringIndex(llGetObjectDesc(), "door;") == -1){
            if (llGetOwnerKey(id) == llGetOwner()){
                closedPos = llGetLocalPos();
                closedRot = llGetLocalRot();
                closedScale = llGetScale();
                isOpen = FALSE;
                if (! (openPos == ZERO_VECTOR && openRot == ZERO_ROTATION && openScale == ZERO_VECTOR))
                    mySetDoorParams(openPos, openRot, openScale, closedPos, closedRot, closedScale);
            }
        }
    }
}