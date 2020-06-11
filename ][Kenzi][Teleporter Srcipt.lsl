integer access_mode = 1;

string text = "Touch To Teleport";
string menu_message = "Select location:";

list location_list = [
"Home",<17.25929, 229.63203, 3604.48389>,
"SSN Club",<99.98943, 215.52785, 2250.86157>,
"Beach",<68.72098, 224.32222, 34.71979>,
"Kristel/Chu",<103.96355, 192.07005, 3997.63696>
];

vector text_color = <1.0,1.0,1.0>;

vector sit_pos = <0.0, 1.1, -0.1>;
vector sit_rot = <-90, 0, 0>;

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
    else
    {
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

integer listen_num = -1;
vector destination = ZERO_VECTOR;
integer selected = FALSE;

default
{
    state_entry()
    {
        llSitTarget(sit_pos, llEuler2Rot(sit_rot*DEG_TO_RAD));
        llSetText(text,text_color,1.0);
        llSetSitText("Teleport");
    }
    
    touch_start(integer int)
    {
        key user = llDetectedKey(0);
        integer access_granted = FALSE;
        if (access_mode == 1)
            access_granted = TRUE;
        else if (access_mode == 2) {
            if (user == llGetOwner())
                access_granted = TRUE;
            else
                llSay(0,"  sorry, owner access only.");
        }
        else if (access_mode == 3) {
            if (llSameGroup(user))
                access_granted = TRUE;
            else
                llSay(0,"  sorry, group memeber access only.");
        }

        if (access_granted){
            list button_list = [];
            integer i = 0;
            for (i = 0; i <= llGetListLength(location_list) - 1; i++){
                if (i < 23)
                    button_list += llList2String(location_list,i);
                i += 1;
            }
            integer menu_chan = 0 - (integer)llFrand(2147483647);
            listen_num  = llListen(menu_chan,"", user,"");
            llDialog(user, menu_message, button_list, menu_chan);
            llSetTimerEvent(60.0);
        }
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
            llWhisper(0,"  location [ "+message+" ] @ "+(string)((integer)destination.x)+", "+(string)((integer)destination.y)+", "+(string)((integer)destination.z)+" selected, right click > Teleport.");
            llSetClickAction(CLICK_ACTION_SIT);
        }
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK){
            key user = llAvatarOnSitTarget();
            if ( (!selected) && (user != NULL_KEY) ){
                llUnSit(user);                        
                llWhisper(0,"  sorry, please touch and select location before teleport.");
            }
            else{
                if (llGetAgentSize(user) != ZERO_VECTOR){
                    vector init_pos = llGetPos();                
                    warpPos(destination);
                    llUnSit(user);
                    llSleep(0.2);
                    warpPos(init_pos);             
                    selected = FALSE;
                    llSetClickAction(CLICK_ACTION_TOUCH);
                }
            }
        }
    }    
}

/*
float color = 0.0;
integer FACE1 = 1;

default
{
    
    state_entry()
    {
        llSetTimerEvent(2.0);
        llSetLinkPrimitiveParams(LINK_THIS, [PRIM_FULLBRIGHT, FACE1, TRUE ]);
    }
    
    timer()
    {
        if (color == 0.0)
            color = 1.0;
        else if (color == 1.0)
            color = 0.0;
        llSetLinkPrimitiveParams(LINK_THIS, [ PRIM_COLOR, FACE1, <0, color, color>, 1.0, PRIM_POINT_LIGHT, TRUE, <0, color, color>, 1.0, 2.0, 0.75 ]);
    }
}
*/