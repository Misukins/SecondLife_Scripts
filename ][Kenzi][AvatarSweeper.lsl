key readKey;
key avatarID;
key managerID;
key manager1ID;
key manager2ID;
key manager3ID;
key manager4ID;
key manager5ID;
key manager6ID;

float distance = 5;
float speed = 4;
float seconds_per_clear = 5;

integer sweepedRight = FALSE;
integer count;
integer lineCount;

string welcome_message;
string settings_file = "Settings";
string real_name;
string objectname;

vector starting_pos;

integer DEBUG = FALSE;

default
{
    state_entry()
    {
        llSetText("Setting up...", <0.58,0,0.83>, 1.0);
        state loadSettings;
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_exit()
    {
        llSetTimerEvent(0);
        llOwnerSay("Initialized.");
    }
}

state loadSettings
{
    state_entry()
    {
        integer found = FALSE;
        integer x;
        count = 0;
        lineCount = 0;
        list savedList = llCSV2List(llGetObjectDesc());
        for (x = 0; x < llGetInventoryNumber(INVENTORY_NOTECARD); x += 1){
            if (llGetInventoryName(INVENTORY_NOTECARD, x) == settings_file)
                found = TRUE; 
        }
        if (found){
            llSetText("Reading Settings file... Please wait...", <0.58,0,0.83>, 1.0);
            readKey = llGetNotecardLine(settings_file, lineCount); 
        }
        else{
            llSetText("Settings Notecard Not Found.", <0.58,0,0.83>, 1.0);
            llResetScript();
        }
    }
    
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();

        if(change & INVENTORY_NOTECARD)
            llResetScript();
    }
    
    dataserver(key requested, string data)
    {
        key keyData;
        string  stringData;
        if (requested == readKey){
            if (data != EOF){
                if ((llSubStringIndex(data, "#") != 0) && (data != "") && (data != " ")){
                    keyData     = (key)data;
                    stringData  = (string)data;
                    if (count == 0){
                        if(keyData == NULL_KEY)
                            managerID = NULL_KEY;
                        else
                            managerID = keyData;
                    }
                    else if (count == 1){
                        if(keyData == NULL_KEY)
                            manager1ID = NULL_KEY;
                        else
                            manager1ID = keyData;
                    }
                    else if (count == 2){
                        if(keyData == NULL_KEY)
                            manager2ID = NULL_KEY;
                        else
                            manager2ID = keyData;
                    }
                    else if (count == 3){
                        if(keyData == NULL_KEY)
                            manager3ID = NULL_KEY;
                        else
                            manager3ID = keyData;
                    }
                    else if (count == 4){
                        if(keyData == NULL_KEY)
                            manager4ID = NULL_KEY;
                        else
                            manager4ID = keyData;
                    }
                    else if (count == 5){
                        if(keyData == NULL_KEY)
                            manager5ID = NULL_KEY;
                        else
                            manager5ID = keyData;
                    }
                    else if (count == 6){
                        if(keyData == NULL_KEY)
                            manager6ID = NULL_KEY;
                        else
                            manager6ID = keyData;
                    }
                    else if (count == 7){
                        if (stringData == "")
                            welcome_message = "";
                        else
                            welcome_message = stringData;
                    }
                    count += 1;
                }
                lineCount += 1;
                readKey = llGetNotecardLine(settings_file, lineCount);
            }
            else {
                if (DEBUG){
                    llOwnerSay("Owner: " + (string)llKey2Name(managerID));
                    llOwnerSay("Manager #1: " + (string)llKey2Name(manager1ID));
                    llOwnerSay("Manager #2: " + (string)llKey2Name(manager2ID));
                    llOwnerSay("Manager #3: " + (string)llKey2Name(manager3ID));
                    llOwnerSay("Manager #4: " + (string)llKey2Name(manager4ID));
                    llOwnerSay("Manager #5: " + (string)llKey2Name(manager5ID));
                    llOwnerSay("Manager #6: " + (string)llKey2Name(manager6ID));
                    llOwnerSay("Welcome: " + (string)welcome_message);
                }
                llOwnerSay("Ready for Service!");
                llSetText("All Done!", <0.58,0,0.83>, 1.0);
                llSleep(1.0);
                llSetText("", <0.58,0,0.83>, 1.0);
                state ready;
            }
        }
    }
}

state ready
{
    state_entry()
    {
        if (DEBUG)
            llOwnerSay("RDY for another one!");
    }
    
    collision_start(integer num)
    {
        if(llDetectedType(0) & AGENT){
            string origName = llGetObjectName();
            llSetObjectName("");
            avatarID = llDetectedKey(0);
            list userName = llParseString2List(llGetDisplayName(avatarID), [""], []);
            real_name = llKey2Name(avatarID);
            llWhisper(0, "Welcome " + (string)userName + " (" + (string)real_name + "), " + welcome_message);
            sweepedRight = !sweepedRight;
            llSetObjectName(origName);
            state start_moving;
        }
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
}

state start_moving
{
    on_rez(integer num)
    {
        llResetScript();
    }

    state_entry()
    {
        if (DEBUG)
            llOwnerSay("start_moving!");
        if(sweepedRight){
            llSetLinkPrimitiveParamsFast(LINK_SET,[PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX]);
            starting_pos = llGetPos();
            vector v = <-1.0, 0.0, 0.0>*llGetRot();
            vector destination = ZERO_VECTOR + v * distance;
            float dist = llVecDist(ZERO_VECTOR,destination);
            float speed = .2 + (dist / speed);
            llSetKeyframedMotion([destination,speed],[KFM_DATA, KFM_TRANSLATION, KFM_MODE, KFM_FORWARD]);
            llSetTimerEvent(speed);
        }
        else{
            llSetLinkPrimitiveParamsFast(LINK_SET,[PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX]);
            starting_pos = llGetPos();
            vector v = <1.0, 0.0, 0.0>*llGetRot();
            vector destination = ZERO_VECTOR + v * distance;
            float dist = llVecDist(ZERO_VECTOR,destination);
            float speed = .2 + (dist / speed);
            llSetKeyframedMotion([destination,speed],[KFM_DATA, KFM_TRANSLATION, KFM_MODE, KFM_FORWARD]);
            llSetTimerEvent(speed);
        }
    }

    timer()
    {
        state returnhome;
    }
}

state returnhome
{
    state_entry()
    {
        if (DEBUG)
            llOwnerSay("Returning home!");
        llSetKeyframedMotion([],[KFM_COMMAND, KFM_CMD_STOP]);
        llSetRegionPos(starting_pos);
        llSetTimerEvent(seconds_per_clear);
    }
    
    timer()
    {
        state ready;
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
}