string      doorOpenSound       = "cb340647-9680-dd5e-49c0-86edfa01b3ac";
string      doorCloseSound      = "e7ff1054-003d-d134-66be-207573f2b535";
string      confirmedSound      = "69743cb2-e509-ed4d-4e52-e697dc13d7ac";
string      accessDeniedSound   = "58da0f9f-42e5-8a8f-ee51-4fac6c247c98";
string      doorBellSound       = "34c9a0b4-5820-0eb3-a639-61dcd5bb7f2b";

string      windowsOpened       = "1d20b793-99ec-3360-af57-3c404a62a350";
string      windowsClosed       = "8a0f2798-e308-7616-3b86-c0baa091b3a3";

integer     windowsFACE         = 2;
float       windowsClosedTrans  = 1.0;
float       windowsOpenedTrans  = 0.5;

float       autoCloseTime       = 10.0;
integer     allowGroupToo       = TRUE;
list        allowedAgentUUIDs   = ["8efecbac-35de-4f40-89c1-2c772b83cafa"];
integer     listenChannel       = 0;

integer     isLocked            = FALSE;
integer     isOpen              = TRUE;
vector      openPos             = ZERO_VECTOR;
rotation    openRot             = ZERO_ROTATION;
vector      openScale           = ZERO_VECTOR;
vector      closedPos           = ZERO_VECTOR;
rotation    closedRot           = ZERO_ROTATION;
vector      closedScale         = ZERO_VECTOR;
key         openerKey           = NULL_KEY;
key         closerKey           = NULL_KEY;
integer     isSetup             = FALSE;
integer     listenHandle        = 0;
string      avatarName          = "";

integer DoorChannel = 14743;

mySayName(integer channel, string objectName, string message)
{
    string name = llGetObjectName();
    llSetObjectName(objectName);
    llSetObjectName(name);
}

mySay(integer channel, string message)
{
    string name = llGetObjectName();
    llSetObjectName("Door");
    llSetObjectName(name);
}

myOwnerSay(string message)
{
    string name = llGetObjectName();
    llSetObjectName("Door");
    llSetObjectName(name);
}

mySoundConfirmed()
{
    if (confirmedSound != "")
        llTriggerSound(confirmedSound, 1.0);
}

mySoundAccessDenied()
{
    if (accessDeniedSound != "")
        llTriggerSound(accessDeniedSound, 1.0);
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

integer myPermissionCheck(key id)
{
    integer hasPermission = FALSE;
    if (isLocked == FALSE)
        hasPermission = TRUE;
    else if (llGetOwnerKey(id) == llGetOwner())
        hasPermission = TRUE;
    else if (allowGroupToo == TRUE && llSameGroup(id))
        hasPermission = TRUE;
    else if (llListFindList(allowedAgentUUIDs, [(string)id]) != -1)
        hasPermission = TRUE;
    return hasPermission;
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
            if (doorBellSound != ""){
                llTriggerSound(doorBellSound, 1.0);
                if (avatarName != ""){
                    avatarName = "";
                }
            }
            if (doorOpenSound != "")
                llTriggerSound(doorOpenSound, 1.0);
            llSetPrimitiveParams([ PRIM_POSITION, openPos, PRIM_ROTATION, ZERO_ROTATION * openRot / llGetRootRotation(), PRIM_SIZE, openScale ]);
            llMessageLinked(LINK_SET, 255, "cmd|door|opened", NULL_KEY);
        }
        else
        {
            if (doorCloseSound != "")
                llTriggerSound(doorCloseSound, 1.0);
            llSetPrimitiveParams([ PRIM_POSITION, closedPos, PRIM_ROTATION, ZERO_ROTATION * closedRot / llGetRootRotation(), PRIM_SIZE, closedScale ]);
            llMessageLinked(LINK_SET, 255, "cmd|door|closed", NULL_KEY);
        }
        
        llSetTimerEvent(0.0);
        if (isOpen == TRUE && autoCloseTime != 0.0)
            llSetTimerEvent(autoCloseTime);
    }
}

default
{
    state_entry()
    {
        listenHandle = llListen(listenChannel, "", NULL_KEY, "");
        llListen(DoorChannel, "", "", "");
        myGetDoorParams();
    }

    touch_start(integer total_number)
    {
        if (myPermissionCheck(llDetectedKey(0)) == TRUE){
            avatarName = llDetectedName(0);
            myToggleDoor();
        }
        else
            mySoundAccessDenied();
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

        if (str == "*Open*"){
            llSetLinkTexture(LINK_THIS, windowsOpened, windowsFACE);
            llSetLinkAlpha(LINK_THIS, windowsOpenedTrans, windowsFACE);
        }
        else if (str == "*Closed*"){
            llSetLinkTexture(LINK_THIS, windowsClosed, windowsFACE);
            llSetLinkAlpha(LINK_THIS, windowsClosedTrans, windowsFACE);
        }
        else if (str == "*Lock Door*"){
            if (myPermissionCheck(id) == TRUE){
                isLocked = TRUE;
                mySoundConfirmed();
            }
            else
                mySoundAccessDenied();
        }
        else if (str == "*Unlock Door*"){
            if (myPermissionCheck(id) == TRUE){
                isLocked = FALSE;
                mySoundConfirmed();
            }
            else
                mySoundAccessDenied();
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "/door opened" && llSubStringIndex(llGetObjectName(), "door;") == -1){
            if (llGetOwnerKey(id) == llGetOwner()){
                mySoundConfirmed();
                openPos = llGetLocalPos();
                openRot = llGetLocalRot();
                openScale = llGetScale();
                isOpen = TRUE;
                if (! (closedPos == ZERO_VECTOR && closedRot == ZERO_ROTATION && closedScale == ZERO_VECTOR))
                    mySetDoorParams(openPos, openRot, openScale, closedPos, closedRot, closedScale);
            }
            else
                mySoundAccessDenied();
        }
        else if (message == "/door closed" && llSubStringIndex(llGetObjectDesc(), "door;") == -1){
            if (llGetOwnerKey(id) == llGetOwner()){
                mySoundConfirmed();
                closedPos = llGetLocalPos();
                closedRot = llGetLocalRot();
                closedScale = llGetScale();
                isOpen = FALSE;
                if (! (openPos == ZERO_VECTOR && openRot == ZERO_ROTATION && openScale == ZERO_VECTOR))
                    mySetDoorParams(openPos, openRot, openScale, closedPos, closedRot, closedScale);
            }
            else
                mySoundAccessDenied();
        }
    }
    
    sensor(integer num_detected)
    {
        if (openerKey != NULL_KEY){
            integer i;
            for (i = 0; i < num_detected; i++){
                if (llDetectedKey(i) == openerKey && myPermissionCheck(llDetectedKey(i)) == TRUE)
                    myOpenDoor();
            }
            openerKey = NULL_KEY;
        }
        else
        {
            integer i;
            for (i = 0; i < num_detected; i++){
                if (llDetectedKey(i) == closerKey && myPermissionCheck(llDetectedKey(i)) == TRUE)
                    myCloseDoor();
            }
            closerKey = NULL_KEY;
        }
    }

    collision_start(integer num_detected)
    {
        integer i;
        for (i = 0; i < num_detected; i++){
            if (myPermissionCheck(llDetectedKey(i)) == TRUE){
                avatarName = llDetectedName(i);
                myOpenDoor();
            }
            else if (llDetectedType(i) & AGENT)
                mySoundAccessDenied();
        }
    }

}