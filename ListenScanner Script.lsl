key _sound_on ="e9a0c36a-dffc-eca0-27b5-3ba4d527dfad";
key _sound_off = "de58f2a6-ba96-d252-7351-ca839d847196";

float _volume = 0.1;

default
{
    state_entry()
    {
        llPreloadSound(_sound_on);
        llPreloadSound(_sound_off);
        llPlaySound(_sound_off, _volume);
        llOwnerSay("is now Offline!");
        llSetTimerEvent(1);
    }

    touch_start(integer total_number)
    {
        state Sniffing;
    }

    timer()
    {
        vector color;
        float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000; //*1000 for milliseconds
        integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
        if (time<=.4) color=<0,1,0>;
        else if (time>.4 && time <=.9) color=<1,1,0>;
        else if (time>.9 && time <= 1.5) color = <1,0,0>;
        else color =<0.514, 0.000, 0.514>;
        llSetText("Scripts:"+(string)count+"\n"+"Script Time:"+((string)time),color,1);
    }

    state_exit()
    {
        llPlaySound(_sound_on, _volume);
        llOwnerSay( "is now Online!" );
        llSetTimerEvent(0);
    }
}

state Sniffing
{
    state_entry()
    {
        integer i = 1;
        for ( ; i <= 65; ++i )
            llListen( i, "", "", "" );
        llSetTimerEvent(1);
    }

    touch_start( integer _n )
    {
        state default;
    }

    listen( integer _chan, string _name, key _id, string _message )
    {
        string object_name = llGetOwnerKey(_id);
        list owner_name = llParseString2List(llGetDisplayName(object_name), [""], []);
        llOwnerSay( "[" + (string) _chan + "]-(" + (string)owner_name + ")[secondlife:///app/agent/" + object_name + "/about (" + _name + ")]" + " " + _message );
    }

    timer()
    {
        vector color;
        float time=llList2Float(llGetObjectDetails(llGetOwner(),[OBJECT_SCRIPT_TIME]),0)*1000; //*1000 for milliseconds
        integer count=llList2Integer(llGetObjectDetails(llGetOwner(),[OBJECT_RUNNING_SCRIPT_COUNT]),0);
        if (time<=.4) color=<0,1,0>;
        else if (time>.4 && time <=.9) color=<1,1,0>;
        else if (time>.9 && time <= 1.5) color = <1,0,0>;
        else color =<0.514, 0.000, 0.514>;
        llSetText("Scripts:"+(string)count+"\n"+"Script Time:"+((string)time),color,1);
    }

    state_exit()
    {
        llSetTimerEvent(0);
    }
}