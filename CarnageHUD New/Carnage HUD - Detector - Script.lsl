string output;
string desc_          = "(c)Vanessa (meljonna Resident) - ";

default
{
    state_entry()
    {
        llSetObjectDesc(desc_);
        llSensorRepeat("", "", AGENT_BY_LEGACY_NAME, 100, PI, 0.1);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        llResetScript();
    }

    no_sensor()
    {
        output = "No avatars detected.";
        llSetText(output, <1, 0, 0>, 1); //Red
    }

    sensor(integer num)
    {  
        integer i;
        output = "";
        for (i = 0; i <num; i++){
            list username = llParseString2List(llGetDisplayName(llDetectedKey(i)), [""], []);
            if(llDetectedKey(0) != NULL_KEY){
                output += (string)username + " (" + llDetectedName(i) + ") - [ " + (string)llRound(llVecDist(llGetPos(), llDetectedPos(i))) + "m ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_FLYING)
                    output += "- F ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_MOUSELOOK)
                    output += "- ML ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_TYPING)
                    output += "- T ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_SITTING)
                    output += "- S ";
                if(llGetAgentInfo(llDetectedKey(i)) & AGENT_AWAY)
                    output += "- A ";
                output += "]\n";
            }
        }
        llSetText(output, <1 ,1 ,1>, 1);
    }
}
