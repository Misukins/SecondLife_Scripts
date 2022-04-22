integer agentTotal;
integer targetIndex = -1;
integer objChan;
integer interval = 60;
integer lsn;
integer maxDialogButtons = 12;
integer maxDialogStringLength = 24;
integer page;
integer pageLen;
integer minPage;
integer maxPage;
integer lockedOn;

string objOwner;
string objName = "[{Amy}]Camera Mod v3 - Teleporter";

list agentKeys;
list agentNames;
list controls;
list menuControls = ["←", "→"];

cbcDisplayPage()
{
    llListenControl(lsn, TRUE);
    llSetTimerEvent(interval);
    string txt;
    txt += "Agents: " + (string)agentTotal + "\n";
    txt += "Page (" + (string)(1 + page) + " / " + (string)(1 + maxPage) + ")\n";
    integer startIndex = page * pageLen;
    integer endIndex = startIndex + pageLen - 1;
    if (endIndex >= agentTotal)
        endIndex = agentTotal - 1;

    list aviBuffer = llList2List(agentNames, startIndex, endIndex);
    endIndex = endIndex % pageLen;
    endIndex += llGetListLength(controls) % 3;
    list avi;
    while (0 <= endIndex - 2){
        avi += llList2List(aviBuffer, endIndex - 2, endIndex);
        endIndex = endIndex - 3;
    }

    if (-1 < endIndex && endIndex < 2)
        avi += llList2List(aviBuffer, 0, endIndex);

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

lookAtAv(vector targetPos)
{
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 10.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 3.0, // ( 0.5 to 10) meters
        // CAMERA_FOCUS, <0,0,0>, // region-relative position
        CAMERA_FOCUS_LAG, 0.1 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 1.0, // (0 to 4) meters
        CAMERA_PITCH, 0.0, // (-45 to 80) degrees
        CAMERA_POSITION, targetPos, // region-relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 1.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, ZERO_VECTOR // <-10,-10,-10> to <10,10,10> meters
    ]);
}

default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TELEPORT | PERMISSION_TRACK_CAMERA | PERMISSION_CONTROL_CAMERA);
    }

    run_time_permissions(integer perm)
    {
        if (perm & (PERMISSION_TELEPORT | PERMISSION_TRACK_CAMERA | PERMISSION_CONTROL_CAMERA))
            state RDY;
        else
           llResetScript();
    }

    link_message(integer from,integer to,string msg,key id)
    {
      if (msg == "RESET"){
          llOwnerSay("Resetting - Cam2Avi Script!");
          llResetScript();
        }
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }
}

state RDY
{
    state_entry()
    {
        llSetObjectName(objName);
        objOwner = llGetOwner();
        objChan = 1 + (integer)llFrand(16777216);
        lsn = llListen(objChan, "", objOwner, "");
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_num)
    {
        if(!lockedOn){
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
                if (llGetAgentSize(agentKey) != ZERO_VECTOR && agentName != "" && agentKey != llGetOwner())
                    targets += [agentName, agentKey];
            }
            targets = llListSort(targets, 2, TRUE);
            agentKeys = llList2ListStrided(llDeleteSubList(targets, 0, 0), 0, -1, 2);
            agentTotal = llGetListLength(agentKeys);
            if (agentTotal <= maxDialogButtons)
                controls = [];
            else
                controls = menuControls;
            pageLen = maxDialogButtons - llGetListLength(controls);
            maxPage = llCeil(agentTotal / pageLen);
            if (agentTotal % pageLen == 0)
                maxPage--;
            for (i = 0; i < agentTotal; i++){
                agentKey = llList2Key(agentKeys, i);
                string agentName;
                agentName = cbcAgentName(agentKey);
                agentName = llGetSubString(agentName, 0, maxDialogStringLength - 1);
                agentNames += [agentName];
            }
            lockedOn = TRUE;
            cbcDisplayPage();
        }
        else
            lockedOn = FALSE;

        lockedOn = !lockedOn;
    }

    listen(integer channel, string name, key id, string msg)
    {
        string operator = llGetOwnerKey(id);
        if (operator == objOwner){
            if (msg == ">"){
                if (page < maxPage)
                    page++;
                else
                    page = 0;
                cbcDisplayPage();
            }
            else if (msg == "<"){
                if (page > minPage)
                    page--;
                else
                    page = maxPage;
                cbcDisplayPage();
            }
            else{
                targetIndex = llListFindList(agentNames, [msg]);
                if (~targetIndex){
                    string agentKey = llList2Key(agentKeys, targetIndex);
                    list answer = llGetObjectDetails(agentKey, [OBJECT_POS]);
                    vector targetPos = llList2Vector(answer, 0);
                    float dist = llVecDist(targetPos,llGetPos());
                    
                    lookAtAv(targetPos);
                    lockedOn = TRUE;
                    //llTeleportAgent(objOwner, "", targetPos, <0.0, 0.0, 0.0>);
                    //llTargetRemove(0);
                    //llStopMoveToTarget();

                    //vector CamPos = llGetCameraPos();
                    //rotation CamRot = llGetCameraRot();
                    //vector CamFoc = CamPos + llRot2Fwd(CamRot);
                    //llTeleportAgent(id, "", CamPos, CamFoc);



                }
                else
                    lockedOn = FALSE;
            }
        }
    }

    link_message(integer from,integer to,string msg,key id)
    {
      if (msg == "RESET"){
          llOwnerSay("Resetting - Teleport 2 Avatar Script!");
          llResetScript();
        }
    }

    timer()
    {
        llListenControl(lsn, FALSE);
    }
}