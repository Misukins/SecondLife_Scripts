key owner   = "92d7a0cf-dbd1-44d1-b4ba-cc495767187a"; //Kenzi
key manager = "1ffac40f-b1ea-41f9-b576-1993b96e36b2"; //Amy

string Welcome = "Welcome";

float gSleep = 3;

default
{
    state_entry()
    {
        
    }

    collision_start(integer total_number)
    {
        key toucher = llDetectedKey(0);
        list name = llParseString2List(llGetDisplayName(toucher), [""], []);
        string realname = llDetectedName(0);
        string origName = llGetObjectName();
        if (toucher == owner)
            return;
        else if (toucher == manager)
            return;
        else {
            llSetObjectName("");
            llSay(0, "/me " + Welcome + " " + (string)name + " (" + realname + ")");
            llSleep(gSleep);
            llSetObjectName(origName);
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
}