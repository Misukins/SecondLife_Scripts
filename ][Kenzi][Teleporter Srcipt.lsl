key gQueryID;
key manager1;
key manager2;
key manager3;
key manager4;
key manager5;
key manager6;

integer listen_num = -1;
integer selected = FALSE;
integer gLine = 0;

list location_list = [
"Amy Home", <58.00000, 62.00000, 3711.36719>
]; //-NOTE MORETO COME...

string Text = "";
string gName = "][Kenzi][Teleporter Config";
string teste = "";
string teletext = "Touch To Teleport";
string menumessage = "Select location: ";

vector telecolor = <1.0,1.0,1.0>;
vector sit_pos = <0.0, 1.1, -0.1>;
vector sit_rot = <-90, 0, 0>;
vector destination = ZERO_VECTOR;

posJump( vector target_position )
{
    llSetPrimitiveParams([PRIM_POSITION, <1.304382E+19, 1.304382E+19, 0.0>, PRIM_POSITION, target_position ]);
}

warpPos( vector destpos ) 
{
    float safety_range = 1000.0;
    integer arrived = FALSE;
    integer within_range = FALSE;
    vector inter_pos = ZERO_VECTOR;
    vector current_pos = llGetPos();
    vector checking_pos = destpos;
    integer jumps = 0;
    list rules = [];
    integer count = 0;
    if (llVecDist(destpos, current_pos) <= safety_range){
        jumps = (integer)(llVecDist(destpos, current_pos) / 10.0) + 1;
        rules = [ PRIM_POSITION, destpos ];
        count = 1;
        while ( ( count = count << 1 ) < jumps)
            rules = (rules=[]) + rules + rules;
        llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) );            
    }
    else{
        while (!arrived){
            current_pos = llGetPos();
            checking_pos = destpos;
            within_range = FALSE;              
            while (!within_range){
                if (llVecDist(checking_pos,current_pos) > safety_range)
                    checking_pos = <(current_pos.x + checking_pos.x) / 2.0,(current_pos.y + checking_pos.y) / 2.0,(current_pos.z + checking_pos.z) / 2.0>;
                else{
                    within_range = TRUE;
                    if (llVecDist(destpos, current_pos) <= safety_range){
                        jumps = (integer)(llVecDist(destpos, current_pos) / 10.0) + 1;
                        rules = [ PRIM_POSITION, destpos ];
                        count = 1;
                        while ( ( count = count << 1 ) < jumps)
                            rules = (rules=[]) + rules + rules;
                        llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) );
                        arrived = TRUE;
                    }                    
                }
            }
            if (!arrived){
                jumps = (integer)(llVecDist(checking_pos, current_pos) / 10.0) + 1;
                rules = [ PRIM_POSITION, checking_pos ];
                count = 1;
                while ( ( count = count << 1 ) < jumps)
                    rules = (rules=[]) + rules + rules;
                llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) );
            }
        }
    }
}

default
{
    on_rez(integer num)
    {
        llResetScript();
    }

    state_entry()
    {
        gQueryID = llGetNotecardLine(gName, gLine);
        llSitTarget(sit_pos, llEuler2Rot(sit_rot*DEG_TO_RAD));
        llSetText(teletext,telecolor,1.0);
        llSetSitText("Teleport");
    }

    dataserver(key query_id, string data)
    {      
        if (query_id == gQueryID){
            if (data != EOF){
                if (teste == "manager1")
                    manager1 = (key)data;
                if (teste == "manager2")
                    manager2 = (key)data;
                if (teste == "manager3")
                    manager3 = (key)data;
                if (teste == "manager4")
                    manager4 = (key)data;
                if (teste == "manager5")
                    manager5 = (key)data;
                if (teste == "manager6")
                    manager6 = (key)data;
                if (teste == "teletext")
                    teletext = (string)data;
                if (teste == "telecolor")
                    telecolor = (vector)data;
                if (teste == "menumessage")
                    menumessage = (string)data;
                if (teste == "sit_pos")
                    sit_pos = (vector)data;
                if (teste == "sit_rot")
                    sit_rot = (vector)data;
                if (llToLower(data) == "[manager1]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "manager1";
                }
                else if (llToLower(data) == "[manager2]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "manager2";
                }
                else if (llToLower(data) == "[manager3]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "manager3";
                }
                else if (llToLower(data) == "[manager4]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "manager4";
                }
                else if (llToLower(data) == "[manager5]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "manager5";
                }
                else if (llToLower(data) == "[manager6]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "manager6";
                }
                else if (llToLower(data) == "[teletext]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "teletext";
                }
                else if (llToLower(data)== "[telecolor]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine); 
                    teste = "telecolor";
                }
                else if (llToLower(data) == "[menumessage]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine); 
                    teste = "menumessage";
                }
                else if (llToLower(data)== "[sit_pos]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine); 
                    teste = "sit_pos";
                }
                else if (llToLower(data)== "[sit_rot]"){
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine); 
                    teste = "sit_rot";
                }
                else{
                    ++gLine;
                    gQueryID = llGetNotecardLine(gName, gLine);
                    teste = "";
                }
            }
            //else
                //NOTE start();
        }
    } 
    
    touch_start(integer int)
    {
        key user = llDetectedKey(0);
        if ((user == manager1) || 
            (user == manager2) || 
            (user == manager3) || 
            (user == manager4) || 
            (user == manager5) || 
            (user == manager6)){
            list button_list = [];
            integer i = 0;
            for (i = 0; i <= llGetListLength(location_list) - 1; i++){
                if (i < 23)
                    button_list += llList2String(location_list,i);
                i += 1;
            }
            integer menu_chan = 0 - (integer)llFrand(2147483647);
            listen_num  = llListen(menu_chan,"", user,"");
            llDialog(user, menumessage, button_list, menu_chan);
            llSetTimerEvent(60.0);
        }
        else
            return;
    }
    
    timer()
    {
        llListenRemove(listen_num);        
        llSetTimerEvent(0.0);        
    }
    
    listen(integer channel, string name, key id, string message) 
    {
        llListenRemove(listen_num);
        llSetTimerEvent(0.0);                
        integer choice_index = llListFindList(location_list, (list)message);
        if (choice_index != -1){
            destination = llList2Vector(location_list,choice_index + 1);
            selected = TRUE;
            llWhisper(0," location [ "+message+" ] @ "+(string)((integer)destination.x)+", "+(string)((integer)destination.y)+", "+(string)((integer)destination.z)+" selected, right click > Teleport.");
            llSetClickAction(CLICK_ACTION_SIT);
        }
    }
    
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
            llResetScript();
        if (change & CHANGED_OWNER)
            llResetScript();
        if (change & CHANGED_LINK){
            key user = llAvatarOnSitTarget();
            if ((selected) && 
                (user == manager1) || 
                (user == manager2) || 
                (user == manager3) || 
                (user == manager4) || 
                (user == manager5) || 
                (user == manager6)){
                vector init_pos = llGetPos();                
                warpPos(destination);
                llUnSit(user);
                llSleep(0.2);
                warpPos(init_pos);             
                selected = FALSE;
            }
        }
    }    
}
