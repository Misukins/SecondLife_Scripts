key user_key    = "92d7a0cf-dbd1-44d1-b4ba-cc495767187a"; //Kenzi
key blank       = "215ab8cb-08b0-256e-71e8-b926e63147c8"; //Design
key toucher;
key the_name_query;

string url = "http://world.secondlife.com/resident/";
string name;
string real_name;
string status;
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
string profile_img_prefix = "<img alt=\"profile image\" src=\"http://secondlife.com/app/image/";

integer profile_key_prefix_length;
integer profile_img_prefix_length;
integer picture_side = 1;
integer status_side = 2;

integer listener;
integer channel;

vector online = <0.000, 0.502, 0.000>;
vector offline = <0.502, 0.000, 0.000>;

list main_menu = [];

menu(key id)
{
    if(id == llGetOwner()){
        main_menu = [ "† Profile †", "† Message †", "† Reset †", "† Exit †" ];
    }
    else{
        main_menu = [ "† Profile †", "† Message †", "† Exit †" ];
    }
    llListenRemove(listener);
    channel = -1000000000 - (integer)(llFrand(1000000000));
    listener = llListen(channel, "", "", "");
    llDialog(id, "Choose an option...", main_menu, channel);
}

default
{
    state_entry()
    {
        profile_key_prefix_length = llStringLength(profile_key_prefix);
        profile_img_prefix_length = llStringLength(profile_img_prefix);
        llSetText("", <1,0,0>, 1.0);
        llSetLinkTexture(LINK_THIS, blank, picture_side);
        llRequestAgentData( user_key, DATA_NAME);
        llSetColor(<1,1,1>, status_side);
    }
    
    dataserver(key queryid, string data)
    {
        real_name = data;
        name = llGetDisplayName(user_key);
        llSetObjectName(real_name + "'s Online Detector");
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
        llSetText("", <1,0,0>, 0.5);
        llSetColor(<1,1,1>, status_side);
        llSetLinkTexture(LINK_THIS, blank, picture_side);
    }
    
    http_response(key request_id,integer status, list metadata, string body)
    {
        string profile_pic;
        integer s1 = llSubStringIndex(body, profile_key_prefix);
        integer s1l = profile_key_prefix_length;
        if(s1 == -1){
            s1 = llSubStringIndex(body, profile_img_prefix);
            s1l = profile_img_prefix_length;
        }
 
        if (s1 == -1)
            profile_pic = blank;
        else{
            profile_pic = llGetSubString(body,s1 + s1l, s1 + s1l + 35);
            if (profile_pic == (string)NULL_KEY)
                profile_pic = blank;
        }
        llSetLinkTexture(LINK_THIS, profile_pic, picture_side);
    }
    
    dataserver(key queryid, string data)
    {
        if ( data == "1" ) {
            status = "\nOnline";
            llSetText(name + "\n (" + real_name + ") " + status, <0,1,0>, 0.5);
            llSetColor(online, status_side);
            llSetPrimitiveParams([PRIM_GLOW, status_side, 0.30]);
        }
        else if (data == "0"){
            status = "\nOffline";
            llSetText(name + "\n (" + real_name + ") " + status, <1,0,0>, 0.5);
            llSetColor(offline, status_side);
            llSetPrimitiveParams([PRIM_GLOW, status_side, 0.30]);
        }
    }
    
    touch_start(integer num_detected)
    {
        toucher = llDetectedKey(0);
        menu(toucher);
    }
    
    listen(integer ch, string name, key id, string msg)
    {
        name = llGetDisplayName(user_key);
        if (msg == "† Profile †")
            llInstantMessage(id, "to see " + name +"'s profile, click this link here: secondlife:///app/agent/" + (string)user_key + "/about");
        else if (msg == "† Message †")
            llInstantMessage(id, "to send " + name +" a message, click this link here: secondlife:///app/agent/" + (string)user_key + "/im");
        else if (msg == "† Reset †")
            llResetScript();
        else if (msg == "† Exit †")
            return;
    } 
}