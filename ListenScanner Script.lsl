key _sound_on ="e9a0c36a-dffc-eca0-27b5-3ba4d527dfad";
key _sound_off = "de58f2a6-ba96-d252-7351-ca839d847196";

float _volume = 0.1;

integer ScannerOnline = FALSE;
integer globalListenHandle  = -0;

ScannerOn()
{
    llOwnerSay( "is now Online!" );
    llTriggerSound(_sound_on, _volume);
    integer i = 1;
    for ( ; i <= 65; ++i )
        globalListenHandle = llListen(i, "", "", "");
}

ScannerOff()
{
    llOwnerSay( "is now Offline!" );
    llTriggerSound(_sound_off, _volume);
    llListenRemove(globalListenHandle);
}

// ► ◄ ▲ ▼ \\
default
{
    state_entry()
    {
        llPreloadSound(_sound_on);
        llPreloadSound(_sound_off);
        if (ScannerOnline)
            llOwnerSay( "is now Online!" );
        else
            llOwnerSay( "is now Offline!" );
    }

    attach(key agent)
    {
        if (agent){
            if (ScannerOnline)
                llOwnerSay( "is now Online!" );
            else
                llOwnerSay( "is now Offline!" );
        }
    }

    touch_start(integer total_number)
    {
        if (ScannerOnline){
            ScannerOff();
        }
        else{
            ScannerOn();
        }
        ScannerOnline = !ScannerOnline;
    }

    listen( integer _chan, string _name, key _id, string _message )
    {
        //list real_name = llParseString2List(llGetDisplayName(_name), [""], []);
        //llOwnerSay( "[" + (string) _chan + "]-[" + real_name + "(" + _name + ")]" + " " + _message );
        llOwnerSay("[" + (string) _chan + "]-[secondlife:///app/agent/" + (string)_id + "/about.] " + _message);
    }
}