key readKey;
key user_key;
key blank;
key toucher;
key the_name_query;

string url = "http://world.secondlife.com/resident/";
string name;
string real_name;
string status;
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
string profile_img_prefix = "<img alt=\"profile image\" src=\"http://secondlife.com/app/image/";
string settings_file = "OnlineBoard Settings";

integer profile_key_prefix_length;
integer profile_img_prefix_length;
integer picture_side = 1;
integer status_side = 2;
integer count;
integer lineCount;
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
        state loadSettings;
    }
}

state loadSettings
{
    state_entry()
    {
        integer found = FALSE;
        integer x;
        count = 0;
        lineCount = 0;
        list savedList = llCSV2List(llGetObjectDesc());
        for (x = 0; x < llGetInventoryNumber(INVENTORY_NOTECARD); x += 1){
            if (llGetInventoryName(INVENTORY_NOTECARD, x) == settings_file)
                found = TRUE; 
        }
        if (found){
            llOwnerSay("Reading Settings Notecard...");
            readKey = llGetNotecardLine(settings_file, lineCount); 
        }
        else{
            llOwnerSay("Settings Notecard Not Found.");
            llResetScript();
        }
    }
    
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();

        if(change & INVENTORY_NOTECARD)
            llResetScript();
    }
    
    dataserver(key requested, string data)
    {
        integer integerData;
        string  stringData;
        if (requested == readKey) {
            if (data != EOF){
                if ((llSubStringIndex(data, "#") != 0) && (data != "") && (data != " ")){
                    integerData = (integer)data;
                    stringData  = (string)data;
                    if (count == 0){
                        if (stringData == "")
                            user_key = "";
                        else
                            user_key = stringData;
                    }
                    else if (count == 1){
                        if (stringData == "")
                            blank = "";
                        else
                            blank = stringData;
                    }
                    count += 1;
                }
                lineCount += 1;
                readKey = llGetNotecardLine(settings_file, lineCount);
            }
            else
            {
                llOwnerSay("===============");
                llOwnerSay("Settings Loaded");
                llOwnerSay("===============");
                llOwnerSay("#User UUID#: " + (string)user_key + " Name: (" + llGetDisplayName(user_key) + ")");
                llOwnerSay("#Blank Texture#: " + (string)blank);
                llOwnerSay("===============");
                llOwnerSay("Ready for Service!");
                state Ready;
            }
        }
    }
}

state Ready
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
        if (msg == "† Profile †")
            llInstantMessage(id, "to see " + name +"'s profile, click this link here: secondlife:///app/agent/" + (string)user_key + "/about");
        else if (msg == "† Message †")
            llInstantMessage(id, "to send " + name +"'s a message, click this link here: secondlife:///app/agent/" + (string)user_key + "/im");
        else if (msg == "† Reset †")
            llResetScript();
        else if (msg == "† Exit †")
            return;
    } 
}