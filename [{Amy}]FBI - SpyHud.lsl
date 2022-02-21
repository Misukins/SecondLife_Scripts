key _sound_on ="e9a0c36a-dffc-eca0-27b5-3ba4d527dfad";
key _sound_off = "de58f2a6-ba96-d252-7351-ca839d847196";
key AvatarKey;

integer listener;
integer menuchannel;
integer agentTotal;
integer targetIndex = -1;
integer objChan;
integer interval = 60;
integer lsn;
integer maxDialogButtons = 10;
integer maxDialogStringLength = 24;
integer page;
integer pageLen;
integer minPage;
integer maxPage;
integer ScannerOn = FALSE;
integer ScriptOn  = FALSE;
integer BothOn    = FALSE;

float _volume = 0.3;

string objName = "][Amy][Spy Scanner v3";
string objOwner;

list agentKeys;
list agentNames;
list controls;
list menuControls = ["←", "→", "▼", "▲"];

menu(key id)
{
    if ((ScannerOn == FALSE) && (ScriptOn == FALSE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "□ Scanner", "□ Scripts", "√ BothOn", "√ SpyAvatar", "▼" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == FALSE) && (ScriptOn == TRUE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "□ Scanner", "■ Scripts", "√ BothOn", "√ SpyAvatar", "▼" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == TRUE) && (ScriptOn == TRUE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "■ Scanner", "■ Scripts", "√ BothOn", "√ SpyAvatar", "▼" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
    else if ((ScannerOn == TRUE) && (ScriptOn == FALSE)){
        llListenRemove(listener);
        menuchannel = llFloor(llFrand(2000000));
        listener = llListen(menuchannel, "", llGetOwner(), "");
        list main_menu = [ "■ Scanner", "□ Scripts", "√ BothOn", "√ SpyAvatar", "▼" ];
        llDialog(id, "Choose an option...", main_menu, menuchannel);
    }
}

StartSniffing()
{
    integer i = 1;
    for (; i <= 65; ++i)
        llListen(i, "", "", "");
}

cbcDisplayPage()
{
    llListenControl(lsn, TRUE);
    llSetTimerEvent(interval);
    string txt;
    txt += "Agents: " + (string)agentTotal + "\n";
    txt += "Page (" + (string)(1 + page) + " / " + (string)(1 + maxPage) + ")\n";
    integer startIndex = page * pageLen;
    integer endIndex = startIndex + pageLen - 1;
    if (endIndex >= agentTotal) {
        endIndex = agentTotal - 1;
    }

    list aviBuffer = llList2List(agentNames, startIndex, endIndex);
    endIndex = endIndex % pageLen;
    endIndex += llGetListLength(controls) % 3;
    list avi;
    while (0 <= endIndex - 2) {
        avi += llList2List(aviBuffer, endIndex - 2, endIndex);
        endIndex = endIndex - 3;
    }

    if (-1 < endIndex && endIndex < 2) {
        avi += llList2List(aviBuffer, 0, endIndex);
    }
    llDialog(objOwner, txt, controls + avi, objChan);
}

string cbcAgentName(string agentKey)
{
    string agentName = llKey2Name(agentKey);
    integer resident = llSubStringIndex(agentName, " Resident");
    if (~resident) {
        agentName = llGetSubString(agentName, 0, resident - 1);
    }
    return agentName;
}

string cbcAgentProfile(string agentKey)
{
    return "secondlife:///app/agent/" + agentKey + "/about";
}

list attPoints =
[
    "",//0
    "Chest",//1
    "Skull",//2
    "L Shoulder",//3
    "R Shoulder",//4
    "L Hand",//5
    "R Hand",//6
    "L Foot",//7
    "R Foot",//8
    "Spine",//9
    "Pelvis",//10
    "Mouth",//11
    "Chin",//12
    "L Ear",//13
    "R Ear",//14
    "L Eye",//15
    "R Eye",//16
    "Nose",//17
    "R Upper Arm",//18
    "R Lower Arm",//19
    "L Upper Arm",//20
    "L Lower Arm",//21
    "R Hip",//22
    "R Upper Leg",//23
    "R Lower Leg",//24
    "L Hip",//25
    "L Upper Leg",//26
    "L Lower Leg",//27
    "Stomach",//28
    "L Pec",//29
    "R Pec",//30
    "",//31
    "",//32
    "",//33
    "",//34
    "",//35
    "",//36
    "",//37
    "",//38
    "Neck",//39
    "Avatar Center",//40
    "L Ring Finger",//41
    "R Ring Finger",//42
    "Tail Base",//43
    "Tail Tip",//44
    "L Wing ",//45
    "R Wing",//46
    "Jaw",//47
    "Alt L Ear",//48
    "Alt R Ear",//49
    "Alt L Eye",//50
    "Alt R Eye",//51
    "Tongue",//52
    "Groin",//53
    "L Hind Foot",//54
    "R Hind Foot"//55
];

string cbcRound(float fNumber)
{
    integer precision = 2;
    string sNumber = (string)fNumber;
    integer sLength = llSubStringIndex(sNumber, ".") + precision;\
    sNumber = llGetSubString(sNumber, 0, sLength);
    return sNumber;
}

default
{
    state_entry()
    {
        llPreloadSound(_sound_on);
        llPreloadSound(_sound_off);
        llSetTimerEvent(0);
        llSetText("",<1,1,1>,1);
        ScannerOn = FALSE;
        ScriptOn  = FALSE;
        BothOn    = FALSE;
        menu(llGetOwner());
    }

    touch_start(integer total_number)
    {
        menu(llGetOwner());
        //llResetScript();
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "▼")
            return;
        else if ((message == "□ Scanner") || (message == "■ Scanner")){
            if (!ScannerOn){
                state Sniffing;
                llOwnerSay("Listen Scanner is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Listen Scanner is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScannerOn = !ScannerOn;
        }
        else if ((message == "□ Scripts") || (message == "■ Scripts")){
            if (!ScriptOn){
                state Script;
                llOwnerSay("Script Counter is now On..");
                llPlaySound(_sound_on, _volume);
                menu(llGetOwner());
                return;
            }
            else{
                state default;
                llOwnerSay("Script Counter is now Off..");
                llPlaySound(_sound_off, _volume);
                menu(llGetOwner());
                return;
            }
            ScriptOn = !ScriptOn;
        }
        else if (message == "√ BothOn"){
            state BothOnState;
            return;
        }
        else if (message == "√ SpyAvatar"){
            state SpyAvatar;
            return;
        }
    }
}

state Sniffing
{
    state_entry()
    {
        llSetObjectName(objName);
        ScannerOn = TRUE;
        BothOn    = FALSE;
        ScriptOn  = FALSE;
        llPlaySound(_sound_on, _volume);
        llOwnerSay("Listen Scanner is now Online..");
        llSetText("",<1,1,1>,1);
        StartSniffing();
    }

    touch_start(integer _n)
    {
        state default;
    }

    listen(integer channel, string name, key id, string message)
    {
        if(channel != menuchannel){
            string object_name = llGetOwnerKey(id);
            list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
            llOwnerSay( "[" + (string) channel + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + name + ")]" + " " + message );
        }
    }

    state_exit()
    {
        ScannerOn = FALSE;
        llOwnerSay("Listen Scanner is now Offline..");
        llPlaySound(_sound_off, _volume);
    }
}

state Script
{
    state_entry()
    {
        llSetObjectName(objName);
        ScriptOn = TRUE;
        ScannerOn = FALSE;
        BothOn    = FALSE;
        llPlaySound(_sound_on, _volume);
        llOwnerSay("Scripts Counter is now Online..");
        llSetTimerEvent(1);
    }

    touch_start( integer _n )
    {
        state default;
    }

    timer()
    {
        vector color;
        float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000;
        integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
        if(time<=.4)
            color=<0,1,0>;
        else if (time>.4 && time <=.9)
            color=<1,1,0>;
        else if (time>.9 && time <= 1.5)
                color = <1,0,0>;
        else
            color =<0.514, 0.000, 0.514>;
        llSetText("Scripts:"+(string)count+"\n"+"Scripts Time:"+((string)time),color,1);
    }

    state_exit()
    {
        llSetTimerEvent(0);
        ScriptOn = FALSE;
        llOwnerSay("Scripts Counter is now Offline..");
        llPlaySound(_sound_off, _volume);
    }
}

state BothOnState
{
    state_entry()
    {
        llSetObjectName(objName);
        ScannerOn   = TRUE;
        ScriptOn    = TRUE;
        BothOn      = TRUE;
        llSetTimerEvent(1);
        llPlaySound(_sound_on, _volume);
        llOwnerSay("Scripts Counter and Channel Sniffer are now Online..");
        StartSniffing();
    }

    touch_start( integer _n )
    {
        llSetTimerEvent(0);
        ScannerOn   = FALSE;
        ScriptOn    = FALSE;
        BothOn      = FALSE;
        llOwnerSay("Scripts Counter and Channel Sniffer are now Offline..");
        llPlaySound(_sound_off, _volume);
        state default;
    }

    listen(integer channel, string name, key id, string message)
    {
        if(channel != menuchannel){
            string object_name = llGetOwnerKey(id);
            list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
            llOwnerSay( "[" + (string) channel + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + name + ")]" + " " + message );
        }
    }

    timer()
    {
        vector color;
        float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000;
        integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
        if(time<=.4)
            color=<0,1,0>;
        else if (time>.4 && time <=.9)
            color=<1,1,0>;
        else if (time>.9 && time <= 1.5)
                color = <1,0,0>;
        else
            color =<0.514, 0.000, 0.514>;
        llSetText("Scripts:"+(string)count+"\n"+"Scripts Time:"+((string)time),color,1);
    }

    state_exit()
    {
        //FIX
    }
}

state SpyAvatar
{
    state_entry()
    {
        list name = llParseString2List(llGetDisplayName(llGetOwner()), [""], []);
        llSetText("Hello\n" + (string)name + ",\n Ready 2\n Spy people!" , <1.0, 0.75, 0.8>, 1);
        ScannerOn = FALSE;
        BothOn    = FALSE;
        ScriptOn  = FALSE;
        llSetObjectName(objName);
        objOwner = llGetOwner();
        objChan = 1 + (integer)llFrand(16777216);
        lsn = llListen(objChan, "", objOwner, "");
        list details = llGetObjectDetails(llGetOwner(), [
            OBJECT_TOTAL_SCRIPT_COUNT, OBJECT_SCRIPT_TIME, OBJECT_SCRIPT_MEMORY
        ]);
        integer scripts = llList2Integer(details, 0);
        string cputime = (string)(llList2Float(details, 1) * 1000);
        string memory = cbcRound(llList2Integer(details, 2) / (1024.0 * 1024.0));
        string fb;
        list status = ["Perfect", "Good", "Average", "Poor"];
        integer s;
        if (scripts > 20 && scripts <= 40) {
            s = 1;
        }
        else if (scripts > 40 && scripts <= 60) {
            s = 2;
        }
        else if (scripts > 60) {
            s = 3;
            fb = "\nNOTE: Please take off some items to reduce your script load!";
        }
        string msg = "Current AVI Specs" + "\nPerformance: " + (string)scripts + " scripts [" + llList2String(status, s) + "]" + fb + "\nScript: " + (string)scripts + " (CPU Time: " + cputime + "ms, " + memory + " MB memory)";
        llOwnerSay(msg);
        llRequestPermissions(objOwner, PERMISSION_TAKE_CONTROLS);
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS) {
            llTakeControls(CONTROL_FWD, TRUE, TRUE);
        }
    }
    
    touch_start(integer num)
    {
        list targets;
        string agentKey;
        string agentName;
        agentNames = [];
        agentKeys = llGetAgentList(AGENT_LIST_REGION, []);
        agentTotal = llGetListLength(agentKeys);
        page = 0;
        integer i;
        for (i = 0; i < agentTotal; i++){
            agentKey = llList2Key(agentKeys, i);
            agentName = llToLower(cbcAgentName(agentKey));
            if (llGetAgentSize(agentKey) != ZERO_VECTOR && agentName != ""){
                targets += [agentName, agentKey];   
            }
        }

        targets = llListSort(targets, 2, TRUE);
        agentKeys = llList2ListStrided(llDeleteSubList(targets, 0, 0), 0, -1, 2);
        agentTotal = llGetListLength(agentKeys);
        if (agentTotal <= maxDialogButtons){
            controls = ["▼", "▲"];
        }
        else{
            controls = menuControls;
        }
        
        pageLen = maxDialogButtons - llGetListLength(controls);
        maxPage = llCeil(agentTotal / pageLen);
        if (agentTotal % pageLen == 0){
            maxPage--;
        }
        
        for (i = 0; i < agentTotal; i++){
            agentKey = llList2Key(agentKeys, i);
            string agentName;
            agentName = cbcAgentName(agentKey);
            agentName = llGetSubString(agentName, 0, maxDialogStringLength - 1);
            agentNames += [agentName];
        }
        cbcDisplayPage();
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        string operator = llGetOwnerKey(id);
        if (operator == objOwner){
            if (msg == "→"){
                if (page < maxPage){
                    page++;
                }
                else{
                    page = 0;
                }
                cbcDisplayPage();
            }
            else if (msg == "←"){
                if (page > minPage){
                    page--;
                }
                else{
                    page = maxPage;
                }
                cbcDisplayPage();
            }
            else if (msg == "▲"){
                llSetObjectName(objName);
                state default;
            }
            else if (msg == "▼")
                return;
            else {
                llSetObjectName(llGetScriptName());
                targetIndex = llListFindList(agentNames, [msg]);
                if (~targetIndex) {
                    string agentKey = llList2Key(agentKeys, targetIndex);
                    vector agentSize = llGetAgentSize(agentKey);
                    if (agentSize == ZERO_VECTOR) {
                        llOwnerSay("No Information can be gathered on " + cbcAgentProfile(agentKey) + ", this avatar appears to have ghosted or has left the region");
                        return;
                    }
                    list items = llGetAttachedList(agentKey);
                    integer itemTotal = llGetListLength(items);
                    integer attScripts;
                    integer attPrims;
                    integer i;
                    string fb;
                    fb += "\n====================";
                    fb += "\nAttachment Report of " + cbcAgentProfile(agentKey) + " [scripts / prims]";
                    fb += "\n====================";
                    fb += "\n ";
                    for (i = 0; i < itemTotal; i++) {
                        string objKey = llList2String(items, i);
                        list objDetails = llGetObjectDetails(objKey, [OBJECT_ATTACHED_POINT, OBJECT_TOTAL_SCRIPT_COUNT, OBJECT_PRIM_EQUIVALENCE, OBJECT_PRIM_COUNT]);
                        integer scripts = llList2Integer(objDetails, 1);
                        integer prims = llList2Integer(objDetails, 2);
                        string fbx;
                        fbx += "\n" + llKey2Name(objKey);
                        fbx += "\nOwner: " + cbcAgentProfile(llList2String(llGetObjectDetails(objKey, [OBJECT_OWNER]), 0)) + " | " + (string)scripts + " scripts | " + llToUpper(llList2String(attPoints, llList2Integer(objDetails, 0))) + " / " + (string)prims + " prims";
                        fbx += "\nCreator: " + cbcAgentProfile(llList2String(llGetObjectDetails(objKey, [OBJECT_CREATOR]), 0)) + " [" + (string)scripts + " scripts]" + " / [" + (string)prims + " prims]";
                        fbx += "\n ";
                        if (llStringLength(fb) + llStringLength(fbx) > 1024) {
                            llOwnerSay(fb);
                            llSetObjectName(":");
                            fb = "\n " + fbx;
                        }
                        else {
                            fb += fbx;
                        }
                        attScripts += scripts;
                        attPrims += prims;
                    }
                    
                    list agentDetails = llGetObjectDetails(agentKey, [OBJECT_TOTAL_SCRIPT_COUNT, OBJECT_RENDER_WEIGHT]);
                    integer totalScripts = llList2Integer(agentDetails, 0);
                    string fbx;
                    fbx += "\n====================";
                    fbx += "\n ";
                    fbx += "\nShape Height: " + llGetSubString((string)(agentSize.z + 0.20 + 0.005), 0, 3) + "m";
                    fbx += "\nScripts: " + (string)totalScripts + " [Clothes: " + (string)attScripts + ", HUDs: " + (string)(totalScripts - attScripts) + "]";
                    fbx += "\nClothes: " + (string)itemTotal + " [Pieces: " + (string)attPrims + "]";
                    fbx += "\nComplexity: " + (string)llList2Integer(agentDetails, 1);
                    fbx += "\n ";
                    fbx += "\n====================";
                    fbx += "\nEnd of Attachment Report of " + cbcAgentProfile(agentKey);
                    fbx += "\n====================";
                    fbx += "\n ";
                    
                    if (llStringLength(fb) + llStringLength(fbx) > 1024) {
                        llOwnerSay(fb);
                        llSetObjectName(":");
                        llOwnerSay(fbx);
                    }
                    else {
                        fb += fbx;
                        llOwnerSay(fb);
                    }
                    /* llSetObjectName(objName);
                    state default; */
                }
            }
        }
    }
    
    timer()
    {
        llListenControl(lsn, FALSE);
    }
    
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY) {
            llResetScript();
        }
        if (change & CHANGED_OWNER) {
            llResetScript();
        }
    }

    state_exit()
    {
        //FIX
    }
}