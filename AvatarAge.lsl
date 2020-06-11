integer AGE_LIMIT;
list agent_list;
 
integer date2days(string data)
{
    integer result;
    list parse_date = llParseString2List(data, ["-"], []);
    integer year = llList2Integer(parse_date, 0);
    result = (year - 2000) * 365;
    list days = [ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ];
    result += llList2Integer(days, (llList2Integer(parse_date, 1) - 1));
    result += llFloor((year-2000) / 4);
    result += llList2Integer(parse_date, 2);
    return result;
}
 
default
{
    on_rez(integer param)
    {
        llResetScript();
    }
 
    state_entry()
    {
        AGE_LIMIT = (integer)llGetObjectDesc();
        if (AGE_LIMIT < 2)
            AGE_LIMIT = 2;
 
        llSetObjectName("Unknown Underage Boot - " + llGetRegionName());
        llVolumeDetect(TRUE);
        if (llOverMyLand(llGetKey()) == FALSE)
            llSay(0, "Requires proper group deeds to work on this land.");
        llSensorRepeat("", "", AGENT, 100.0, PI, 1.0);
        llOwnerSay("Set Avatar age in the description, currently it is set for " +
            (string)AGE_LIMIT + " days.");
    }
 
    sensor(integer num_detected)
    {
        if (llOverMyLand(llGetKey()) == FALSE)
            return;

        integer i;
        for (i = 0; i < num_detected; i++)
        {
            key agent = llDetectedKey(i);
            if (llSameGroup(agent) == FALSE)
            {
                if (llListFindList(agent_list, [ agent ]) < 0)
                {
                    if (llGetListLength(agent_list) == 0)
                    {
                        agent_list += agent;
                        llRequestAgentData(llList2Key(agent_list, 0), DATA_BORN);
                    }
                    else
                        agent_list += agent;
                }
            }
        }
    }
 
    dataserver(key queryid, string data)
    {
        AGE_LIMIT = (integer)llGetObjectDesc();
        integer today = date2days(llGetDate());
        integer age = date2days(data);
        key agent = llList2Key(agent_list, 0);
        string name = llKey2Name(agent);
 
        if (AGE_LIMIT < 2)
        {
            AGE_LIMIT = 2;
            llSetObjectDesc((string)AGE_LIMIT + " : SET AGE LIMIT HERE");
        }
 
        if (name != "")
        {
            if ((today - age) < AGE_LIMIT)
            {
                if (llOverMyLand(agent))
                {
                    llSay(0, name + ", you are too young to be here.");
                    llTeleportAgentHome(agent);
                }
            }
            else
            {
                //
            }
        }
        else
            llTeleportAgentHome(agent);
 
        agent_list = llDeleteSubList(agent_list, 0, 0);
        if (llGetListLength(agent_list) != 0)
            llRequestAgentData(llList2Key(agent_list, 0), DATA_BORN);
    }
}