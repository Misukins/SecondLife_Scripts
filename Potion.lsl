key user;
integer _chan = 1001;
integer DEBUG = TRUE;

default
{
    state_entry()
    {
        llListen(_chan, "", llGetOwner(), "");
    }
	
	attach(key attached)
    {
        if(attached != NULL_KEY)
        {
			//DEBUG
			if (DEBUG == TRUE)
                llOwnerSay("DEBUG :: Channel 1001: Potion");
            if(llGetOwnerKey() == llGetOwner()){
                llRegionSay(_chan, "potion");
                llOwnerSay("Potion used!");
                //llDie();
            }
        }
    }
}
