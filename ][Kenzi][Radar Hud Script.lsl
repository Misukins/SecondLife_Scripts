integer counter = 0;
key owner = NULL_KEY;
integer RStat = TRUE;
 
set_time(float Stime, string Stext, integer Scounter)
{
    llSetText(Stext, <0.667, 0.667, 0.667>, 1.0);
    if (Stime != 0.2)
        llSetTimerEvent(Stime);
    counter = Scounter;
}

string status(key id)
{
    string status = "";
    integer info = llGetAgentInfo(id);
    if (info & AGENT_AWAY       ) status += "A";
    if (info & AGENT_BUSY       ) status += "B";
    if (info & AGENT_TYPING     ) status += "T";
    if (info & AGENT_SITTING    ) status += "S";    
    if (info & AGENT_FLYING     ) status += "F";
    if (info & AGENT_CROUCHING  ) status += "C";
    if (info & AGENT_MOUSELOOK  ) status += "M";
    if (info & AGENT_WALKING    )
    {
        if ( info & AGENT_ALWAYS_RUN )
            status += "R";
        else
            status += "W";
    }

    if (status != "")
        return " (" + status + ")";
    else
        return "";
}

default
{
    state_entry()
    {
        if(owner)  ;
        else{
            llSetMemoryLimit(40000);
            owner = llGetOwner();
            set_time(10.0, "[- Starting -]", 0);
        }
    }
 
    on_rez(integer start_param)
    {
        llResetScript();
    }
 
    changed(integer change)
    {
        if(change & (CHANGED_REGION))
            state teleport;
    }
 
    touch_start(integer total_number)
    {   
        if (llGetAttached()){
            if (counter) {
                set_time(0.0, "[- Off -]", 0);
                RStat = FALSE;
            }
            else if (!RStat){
                set_time(10.0, "[- Starting -]", 0);
                RStat = TRUE;
            }
        }
    }
 
    timer()
    {
        list AvatarsDetect = llGetAgentList(AGENT_LIST_REGION, []);
        integer numOfAvatars = llGetListLength(AvatarsDetect);
        if (!llGetAttached()){
            if (llGetObjectPrimCount(llGetKey())){
                set_time(0.0, "[- Off -]", 0);
                RStat = FALSE;
            }
        }
        else if (numOfAvatars < 2){
            if (counter != 2)
                set_time(0.2, "[- Nobody -]", 2);
        }
        else if (numOfAvatars > 100)
            return;
        else{
            integer index;
            list NewTab = [];
            vector currentPos = llGetPos();
            integer Zfix = numOfAvatars;
            for (index = 0; index < Zfix; ++index){
                key AvKey = llList2Key(AvatarsDetect, index);
                list AvPos = llGetObjectDetails(AvKey, [OBJECT_POS]);
                if (AvPos)
                    NewTab += [llVecDist(currentPos, llList2Vector(AvPos, 0)), AvKey];
                else
                    --numOfAvatars;
            }
 
            if (numOfAvatars > 1){
                AvatarsDetect = [];
                NewTab = llListSort(NewTab, 2, TRUE);
                string mode = "[- Sim: " + (string)(numOfAvatars) + " -]";
                numOfAvatars *= 2;
                for(index = 0; index < numOfAvatars; index += 2){
                    key id = llList2Key(NewTab, index + 1);
                    /*if (Zfix){
                        if (id == owner){
                            Zfix = FALSE;
                            jump Ignore;
                        }
                    }*/
                    list scriptInfo = llGetObjectDetails(id, [OBJECT_TOTAL_SCRIPT_COUNT, OBJECT_RUNNING_SCRIPT_COUNT, OBJECT_SCRIPT_TIME, OBJECT_SCRIPT_MEMORY]);
                    string DName = llGetDisplayName(id) + " (" + llKey2Name(id) + ") Scripts: " + llList2String( scriptInfo, 1 ) + "/" + llList2String( scriptInfo, 0 ) + ", ";
                    string DLang = "?";
                    if (DName) {
                        DLang = llGetAgentLanguage(id);
                        integer Dlenght = llStringLength(DLang);
                        if (Dlenght == 2)  ;
                        else if (Dlenght == 5){
                            if (DLang == "en-us")
                                DLang = "en";
                            else
                                DLang = "xx";
                        }
                        else
                            DLang = "xx";
                    }
                    else
                        DName = "???";
                    DName += " [" + DLang + "-" + (string)llList2Integer(NewTab, index) + "m]" + status(id);
                    if (index > 18){
                        DName = mode + "\n" + DName;
                        if (llStringLength(DName) > 254)
                            jump affich;
                        else
                            mode = DName;
                    }
                    else
                        mode += "\n" + DName;
                    @Ignore;
 
                }
                @affich;
                NewTab = [];
                set_time(0.2, mode, 1);
            }
        }
    }
}
 
state teleport
{
    state_entry()
    {
        if (counter)
            set_time(10.0, "[- Searching -]", 0);
        state default;
    }
 
    on_rez(integer start_param)
    {
        llResetScript();
    }
 
    timer()
    {
        return;
    }
}