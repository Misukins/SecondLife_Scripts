integer CHANNEL;
integer interval = 30;
integer LISTENER;
integer COUNT = 1;

vector sit_rot = <0.0, 0.0, 0.0>;
vector sit_pos = <0.0, 0.0, 1.0>;

string Context = "Dance";
string animation;
string currentmode = "Random";

key AVATAR;

list ANIM_MENU;
list REF_MENU;
list Adjusment;

UpdateSitTarget(key requester)
{
    key user = llAvatarOnSitTarget();
    if(user)
    {
        vector size = llGetAgentSize(user);
        if(size)
        {
            vector localpos = ZERO_VECTOR;
            if(llGetLinkNumber() > 1)
            {
                localpos = llGetLocalPos();
            }
            integer linkNum = llGetNumberOfPrims();
            do
            {
                if(user == llGetLinkKey( linkNum ))
                {
                    llSetLinkPrimitiveParamsFast(linkNum, [PRIM_POS_LOCAL, (sit_pos + <0.0, 0.0, 0.4>)]);
                    jump end;
                }
            }while( --linkNum );
        }
        else
        {
            llUnSit(user);
        }
    }
    @end;
}

integer RandInt(integer lower, integer higher)
{
    integer range = higher - lower;
    integer result = llFloor(llFrand(range + 1)) + lower;
    return result;
}

string RandomDance()
{
    string output;
    integer dancenum;
    output = llGetInventoryName(INVENTORY_ANIMATION, RandInt(0, llGetInventoryNumber(INVENTORY_ANIMATION) -1));
    if (output == animation)
    {
        output = RandomDance();
    }
    return output;
}

Stop_All_Animations(key avatar)
{
    list animations = llGetAnimationList(avatar);
    integer i;
    for(i = 0; i < llGetListLength(animations); ++i)
    {
        llStopAnimation(llList2Key(animations, i));
    }
}

PresentMenu()
{
    integer num = llGetInventoryNumber(INVENTORY_ANIMATION);
    if(num <= 11)
    {
        ANIM_MENU = ["Random"];
        REF_MENU = ["Random"];
        integer i;
        for(i = 0; i < num; ++i)
        {
            string name = llGetInventoryName(INVENTORY_ANIMATION, i);
            if(name != "")
            {
                ANIM_MENU += name;
                integer x = llStringLength(name);
                if(x > 12)
                {
                    name = llGetSubString(name, x - 11, x - 1);
                }
                REF_MENU += name;
            }
        }
    }
    else
    {
        ANIM_MENU = ["Previous", "Random", "Next"];
        REF_MENU = ["Previous", "Random", "Next", "Adjust"];
        integer start = (COUNT * 8) - 8;
        integer stop = (COUNT * 8) - 1;
        integer i;
        for(i = start; i <= stop; ++i)
        {
            string name = llGetInventoryName(INVENTORY_ANIMATION, i);
            if(name != "")
            {
                ANIM_MENU += name;
                integer x = llStringLength(name);
                if(x > 12)
                {
                    name = llGetSubString(name, x - 10, x - 1);
                }
                REF_MENU += name;
            }
        }
    }
    llSetTimerEvent(600);
    CHANNEL = (integer)llFrand((2147283648) + 100000) * -1;
    LISTENER = llListen(CHANNEL, "", llDetectedKey(0), "");
    llDialog(llAvatarOnSitTarget(), "Please choose an option", REF_MENU, CHANNEL);
}

AdjusmentMenu()
{
    Adjusment = ["Height(++)", "Height(+)", "Height(--)", "Height(-)"];
    llSetTimerEvent(600);
    CHANNEL = (integer)llFrand((2147283648) + 100000) * -1;
    LISTENER = llListen(CHANNEL, "", llDetectedKey(0), "");
    llDialog(llAvatarOnSitTarget(), "Please choose an option", Adjusment, CHANNEL);
}

default
{
    state_entry()
    {
        llSetSitText(Context);
        llSitTarget(sit_pos, llEuler2Rot(sit_rot*DEG_TO_RAD));
        if (llGetInventoryNumber(INVENTORY_ANIMATION) > 0)
        {
            integer dancenum;
            animation = llGetInventoryName(INVENTORY_ANIMATION,0);
        }
        else
        {
            llWhisper(0, "***Where are all your dances?!***");
        }
    }

    on_rez(integer start_parm)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            if(llAvatarOnSitTarget() != NULL_KEY)
            {
                AVATAR = llAvatarOnSitTarget();
                llRequestPermissions(AVATAR, (PERMISSION_TRIGGER_ANIMATION));
            }
            else
            {
                Stop_All_Animations(AVATAR);
                llSetTimerEvent(0);
            }
        }
    }
    
    run_time_permissions(integer perm)
    {
        if(perm & (PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS))
        {
            //key id = llDetectedKey(0);
            //integer sameGroup = llSameGroup(id);
            //if(!sameGroup)
            //{
                Stop_All_Animations(AVATAR);
                string animation = llGetInventoryName(INVENTORY_ANIMATION, 0);
                AVATAR = llAvatarOnSitTarget();
                //llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
                //is_sitting = TRUE;
                //llInstantMessage(AVATAR, "\nuse Up/Down arrow key to change your height\nuse left/right for small height change.");
                llStartAnimation(animation);
                llSetTimerEvent(0);
                PresentMenu();
            /*}
            else
            {
                llUnSit(id);
                llPushObject(id,<0,0,10>, <0,0,0>, TRUE);
            }*/
        }
    }
    
    touch_start(integer x)
    {
        if(llDetectedKey(0) == llAvatarOnSitTarget())
        {
            PresentMenu();
        }
    }
    
    timer()
    {
        string olddance = animation;
        if (currentmode == "Random")
        {
            animation = RandomDance();
            llStopAnimation(olddance);
            llStartAnimation(animation);
        }
        else if (currentmode == "Cycle")
        {
            integer dancenum;
            integer NOTFOUND = TRUE;
            while (NOTFOUND)
            {
                if (olddance == llGetInventoryName(INVENTORY_ANIMATION, dancenum))
                {
                    NOTFOUND = FALSE;
                }
                dancenum++;
            }
            if (dancenum >= llGetInventoryNumber(INVENTORY_ANIMATION))
            {
                dancenum = 0;
            }
            animation = llGetInventoryName(INVENTORY_ANIMATION, dancenum);
            llStopAnimation(olddance); 
            llStartAnimation(animation);
        }
        llListenRemove(LISTENER);
        llSetTimerEvent(interval);
    }
    
    listen(integer ch, string name, key id, string msg)
    {
        llListenRemove(LISTENER);
        llSetTimerEvent(0);
        if(msg == "Random")
        {
            llSetTimerEvent(interval);
            currentmode = "Random";
        }
        else if(msg == "Next")
        {
            float MAX = llGetInventoryNumber(INVENTORY_ANIMATION);
            MAX = MAX / 9.0;
            integer MAXIMUM = llCeil(MAX);
            ++COUNT;
            if(COUNT > MAXIMUM)
            {
                COUNT = 1;
            }
            PresentMenu();
        }
        else if(msg == "Previous")
        {
            if(COUNT > 1)
            {
                --COUNT;
            }
            else
            {
                float MAX = llGetInventoryNumber(INVENTORY_TEXTURE);
                MAX = MAX / 10.0;
                integer MAXIMUM = llCeil(MAX);
                COUNT = MAXIMUM;
            }
            PresentMenu();
        }
        else if (msg == "Adjust")
        {
            AdjusmentMenu();
        }
        else if (msg == "Height(++)")
        {
            sit_pos.z += 0.055;
            UpdateSitTarget(id);
            AdjusmentMenu();
            return;
        }
        else if (msg == "Height(+)")
        {
            sit_pos.z += 0.025;
            UpdateSitTarget(id);
            AdjusmentMenu();
            return;
        }
        else if (msg == "Height(--)")
        {
            sit_pos.z -= 0.055;
            UpdateSitTarget(id);
            AdjusmentMenu();
            return;
        }
        else if (msg == "Height(-)")
        {
            sit_pos.z -= 0.025;
            UpdateSitTarget(id);
            AdjusmentMenu();
            return;
        }
        else if(PERMISSION_TRIGGER_ANIMATION && id == llAvatarOnSitTarget())
        {
            Stop_All_Animations(id);
            integer pos = llListFindList(REF_MENU, [msg]);
            msg = llList2String(ANIM_MENU, pos);
            llStartAnimation(msg);
            PresentMenu();
        }
        else
        {
            if(llAvatarOnSitTarget() != NULL_KEY)
            {
                llRequestPermissions(llAvatarOnSitTarget(), (PERMISSION_TRIGGER_ANIMATION));
            }
        }
    }
    
    link_message(integer n, integer num, string message, key id)
    {
        if(message == "signed in")
            llSetPayPrice(20, [20 ,50, 100, 150]);
        else if(message == "signed out")
            llSetPayPrice(PAY_DEFAULT, [PAY_DEFAULT ,PAY_DEFAULT, PAY_DEFAULT, PAY_DEFAULT]);
    }
}
