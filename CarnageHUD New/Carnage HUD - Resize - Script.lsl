key owner;

integer new = TRUE;
integer LinkSet = TRUE;
integer Prim;
integer Channel;
integer Listener;

string desc_          = "(c)Vanessa (meljonna Resident) - ";

Chan()
{
    llListenRemove(Listener);
    Channel = (integer)(llFrand(999999.0) * -1);
    Listener = llListen(Channel, "", owner, "");
    llSetTimerEvent(60);
}

menu1()
{
    Chan();
    if(new){
        llDialog(owner, "\nYour first run or reset of this script.\nDo you whish to save current parameters?",
        ["Save","Later"], Channel);
    }
    else{
        llDialog(owner, "\nselect an option\nAll = complete Object",
        ["All", "Done"], Channel);
    }
}

menu2()
{
    Chan();
    llDialog(owner, "\n+ - = resize\nSave = record all parameters\nRestore = restore saved parameters",
    ["Save", "Restore", "Done", "-1%", "-5%", "-10%", "+1%", "+5%", "+10%"], Channel);
}

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        owner = llGetOwner();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    touch_start(integer total_number)
    {
        owner = llGetOwner();
        if(llDetectedKey(0) == owner){
            if(llGetAttached() != 0){
                if(llGetAgentInfo(owner)){
                    Prim = llDetectedLinkNumber(0);
                    menu1();
                }
            }
            else{
                Prim = llDetectedLinkNumber(0);
                menu1();
            }
        }
    }

    listen(integer channel, string name, key id, string msg)
    {
        float shift = 0;
        vector position;
        vector size;
        list link;
        integer i;
        if(msg == "All"){
            LinkSet = TRUE;
            menu2();
        }
        else if(msg == "Done" || msg == "Later"){
            llListenRemove(Listener);
            llSetTimerEvent(0);
        }
        else if(msg == "-1%")
            shift = 0.99;
        else if(msg == "-5%")
            shift = 0.95;
        else if(msg == "-10%")
            shift = 0.9;
        else if(msg == "+1%")
            shift = 1.01;
        else if(msg == "+5%")
            shift = 1.05;
        else if(msg == "+10%")
            shift = 1.1;
        else if(msg == "Save"){
            llOwnerSay("Please wait...");
            if(!LinkSet){
                link = llGetLinkPrimitiveParams(Prim, [PRIM_SIZE , PRIM_POSITION]);
                position = llList2Vector(link, 1);
                position = (position - llGetRootPosition()) / llGetRootRotation();
                size = llList2Vector(link, 0);
                llSetLinkPrimitiveParamsFast(Prim,[PRIM_DESC, desc_ + (string)size + "#" + (string)position]);
            }
            else{
                for(i = 0; i <= llGetNumberOfPrims(); i++){
                    link = llGetLinkPrimitiveParams(i, [PRIM_SIZE , PRIM_POSITION]);
                    size = llList2Vector(link, 0);
                    position = llList2Vector(link, 1);
                    position = (position - llGetRootPosition()) / llGetRootRotation();
                    if(i > 1)
                        llSetLinkPrimitiveParamsFast(i,[PRIM_DESC,desc_ + (string)size + "#" + (string)position]);
                    else
                        llSetLinkPrimitiveParamsFast(i,[PRIM_DESC,desc_ + (string)size]);
                }
                new = FALSE;
            }
            llOwnerSay("All parameters are stored");
            menu2();
        }
        else if(msg == "Restore"){
            if(!new){
                llOwnerSay("Please wait...");
                if(!LinkSet){
                    link = llGetLinkPrimitiveParams(Prim, [PRIM_DESC]);
                    list parsed = llParseString2List(llList2CSV(link), ["#"], []);
                    string vect = llList2String(parsed, 0);
                    size = (vector)vect;
                    llSetLinkPrimitiveParamsFast(Prim, [PRIM_SIZE, size]);
                }
                else{
                    for(i = 0; i <= llGetNumberOfPrims(); i++){
                        link = llGetLinkPrimitiveParams(i, [PRIM_DESC]);
                        list parsed = llParseString2List(llList2CSV(link), ["#"], []);
                        string vect = llList2String(parsed, 0);
                        size = (vector)vect;
                        string posi = llList2String(parsed, 1);
                        position = (vector)posi;
                        if(i > 1)
                            llSetLinkPrimitiveParamsFast(i, [PRIM_SIZE, size, PRIM_POSITION, position]);
                        else
                            llSetLinkPrimitiveParamsFast(i, [PRIM_SIZE, size]);
                    }
                }
                llOwnerSay("All stored parameters restored.");
                menu2();
            }
            else if(new){
                llOwnerSay("Please first save all paremeters to use this.");
            }

        }

        if(shift != 0){
            llOwnerSay("Please wait...");
            if(!LinkSet){
                link = llGetLinkPrimitiveParams(Prim, [PRIM_SIZE]);
                size = llList2Vector(link, 0) * shift;
                llSetLinkPrimitiveParamsFast(Prim, [PRIM_SIZE, size]);
            }
            else{
                for(i = 0; i <= llGetNumberOfPrims(); i++){
                    link = llGetLinkPrimitiveParams(i, [PRIM_SIZE, PRIM_POSITION]);
                    size = llList2Vector(link, 0) * shift;
                    position = llList2Vector(link, 1);
                    position = (position - llGetRootPosition()) / llGetRootRotation() * shift;
                    if(i > 1)
                        llSetLinkPrimitiveParamsFast(i, [PRIM_SIZE, size, PRIM_POSITION, position]);
                    else
                        llSetLinkPrimitiveParamsFast(i, [PRIM_SIZE, size]);
                }
            }
            llOwnerSay("Finish.");
            menu2();
        }
    }

    timer()
    {
        llSetTimerEvent(0);
        llListenRemove(Listener);
        llOwnerSay("Listener timeout, please touch again to use the menu.");
    }

    on_rez(integer Dae)
    {
        if(new)
            llResetScript();
    }
}