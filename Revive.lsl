key user;
integer _chan = 1001;
integer DEBUG = TRUE;

default
{
    state_entry()
    {
        user = llGetOwner();
        llListen(_chan, "", user, "");
    }
	
	attach(key attached)
    {
        if(attached != NULL_KEY)
        {
			//DEBUG
			if (DEBUG == TRUE)
				llOwnerSay("DEBUG :: Channel 1001: revive");
            llSay(_chan, "revive");
			llOwnerSay("Reviver used!");
			//llDie();
        }
    }
}