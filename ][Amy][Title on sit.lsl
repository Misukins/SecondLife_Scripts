key AVATAR;

string userName;
string real_name;

default
{
    state_entry()
    {
        llSetText("", <0.58,0,0.83>, 1.0);
    }

    on_rez(integer start_parm)
    {
        llResetScript();
    }

    changed(integer change)
    {
        key sittingAvatar = llAvatarOnLinkSitTarget(LINK_ROOT);
        if(sittingAvatar) {
            AVATAR = sittingAvatar;
            list userName = llParseString2List(llGetDisplayName(AVATAR), [""], []);
            real_name = llKey2Name(AVATAR);
            llSetText((string)userName + " (" + (string)real_name + "), ", <1,1,1>, 1.0);
            llSleep(0.5);
            state register;
        }
        /*else {
            llSetText("", <0.58,0,0.83>, 1.0);
            return;
        }*/
        if (change & CHANGED_OWNER)
            llResetScript();
    }
}

state register
{
    state_entry()
    {
        llRequestAgentData(userID, DATA_NAME);
    }
    
    dataserver(key queryid, string data)
    {
        real_name = data;
        userName = llGetDisplayName(userID);
        //llSleep(0.5);
        //state registered;
    }

    changed(integer change)
    {
        key sittingAvatar = llAvatarOnSitTarget();
        if(userID != sittingAvatar)
        {
            userID = sittingAvatar;
            llSleep(0.5);
            state default;
        }     
    }
}
