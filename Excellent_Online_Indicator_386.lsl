key user_key = "";
integer time = 30;
string url = "http://world.secondlife.com/resident/";
key blank = TEXTURE_BLANK;
string name;
key toucher;
string status;

string profile_key_prefix = "<meta name=\"imageid\" content=\"";
string profile_img_prefix = "<img alt=\"profile image\" src=\"http://secondlife.com/app/image/";
integer profile_key_prefix_length;
integer profile_img_prefix_length;

default
{
    state_entry()
    {
        profile_key_prefix_length = llStringLength(profile_key_prefix);
        profile_img_prefix_length = llStringLength(profile_img_prefix);
        llSetText("", <1,0,0>, 1.0);
        llSetTexture(blank, ALL_SIDES);
        llRequestAgentData( user_key, DATA_NAME);   
    }
    dataserver(key queryid, string data)
    {
        name = data;
        llSetObjectName(name + "'s Online Detector");
        state show;
    }
}
state show
{   
    state_entry()
    {
        llSetTimerEvent(10);
    } 
    timer()
    {
        llHTTPRequest( url + (string)user_key,[HTTP_METHOD,"GET"],"");
        llRequestAgentData( user_key, DATA_ONLINE);   
    } 
    on_rez(integer start_param)
    {
        llSetText("", <1,0,0>, 1.0);
        llSetTexture(blank, ALL_SIDES);
    } 
    http_response(key request_id,integer status, list metadata, string body)
    {
        string profile_pic;
        integer s1 = llSubStringIndex(body, profile_key_prefix);
        integer s1l = profile_key_prefix_length;
        if(s1 == -1)
        {
            s1 = llSubStringIndex(body, profile_img_prefix);
            s1l = profile_img_prefix_length;
        }
 
        if (s1 == -1)
        {
            profile_pic = blank;
        }
        else
        {
            profile_pic = llGetSubString(body,s1 + s1l, s1 + s1l + 35);
            if (profile_pic == (string)NULL_KEY)
            {
                profile_pic = blank;
            }
        }
        llSetTexture(profile_pic, ALL_SIDES);
    }
   

    dataserver(key queryid, string data)
    {
        if ( data == "1" ) 
        {
            status = " is online";
           llMessageLinked(2, 16, "Turn On", "");
            llSetText(name + status, <0,1,0>, 1.0);
        }
        else if (data == "0")
        {
            status = " is offline";
            llMessageLinked(2, 16, "Turn Off", "");
            llSetText(name + status, <1,0,0>, 1.0);
        }
 
    }
    touch_start(integer num_detected)
    {
        toucher = llDetectedKey(0);
        state msg;
    }
}
state msg
{
    state_entry()
    {
        llListen(0,"",toucher,"");
        llInstantMessage(toucher, "write your message to " + name +" - you have " +(string)time + " seconds");
        llInstantMessage(toucher, "to see " + name +"'s profile, click this link here: secondlife:///app/agent/" + (string)user_key + "/about");
        llSetTimerEvent(time);   
    }
    listen(integer ch, string name, key id, string msg)
    {
        llInstantMessage(user_key, llKey2Name(toucher) + " sent you a message from " + llGetRegionName() + ": " + msg);
        llInstantMessage(toucher, "message is sent.");
        llListenRemove(0);
        state show;
    }
    timer()
    {
        llInstantMessage(toucher, "time is up - touch again to write a message");
        llListenRemove(0); 
        state show;
    }
}

