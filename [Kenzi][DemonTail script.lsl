key owner;

integer channel;
integer listen_handle;

integer normal = TRUE;
integer public = TRUE;

integer _link_a = 2;
integer _link_b = 3;
integer _link_c = 4;
integer _link_d = 6;
integer _link_e = 11;

integer _texture_link_a = 5;
integer _texture_link_b = 7;
integer _texture_link_c = 16;

string texture_a = "36fe2e28-a167-6cdd-9238-6287d343f5f0";
string texture_b = "b05095e9-e1a3-e398-4b34-e9fcf0d71b87";
string texture_c = "63e49be5-f8a4-318b-be17-4ddd75e302af";
string texture_d = "d9d7ca27-1744-35ac-2453-1604f4b3ee5c";
string announce_type = "whisper";

string menu_text = "<owners_first_name>'s Tail Menu\nWhat do you want to do with my tail <users_first_name>?";

list buttons            = ["-Hug-", "-Stroke-", "-Kiss-", "-Sniff-", "-Clean-", "-Pet-", "-Bite-", "-Lick-", "-Pull-", "-Put in-", "-Grabs out-", "-Hump-" ];

list messages = [
"<users_first_name> picks up <owners_first_name>'s tail and hugs it gently.",
"<users_first_name> gently strokes their fingers through <owners_first_name>'s tail.",
"<users_first_name> picks up <owners_first_name>'s tail and kisses it.",
"<users_first_name> picks up <owners_first_name>'s tail and sniffs it a few times.",
"<users_first_name> picks up <owners_first_name>'s tail and picks out all the dirt.",
"<users_first_name> picks up and begins petting <owners_first_name>'s tail.",
"<users_first_name> picks up and bites <owners_first_name>'s tail, when nobody's looking.",
"<users_first_name> picks up and licks <owners_first_name>'s tail to get a meow out of them.",
"<users_first_name> picks up and pulls <owners_first_name>'s tail.",
"<users_first_name> picks up and puts old gum in <owners_first_name>'s tail.",
"<users_first_name> picks up and grabs old gum from <owners_first_name>'s tail.",
"<users_first_name> picks up and humps <owners_first_name>'s tail."
];

vector start;
vector white    = <1.0, 1.0, 1.0>;
vector black    = <0.0, 0.0, 0.0>;
vector purple   = <0.5, 0.0, 0.5>;
vector pink     = <1.0, 0.75, 0.8>;
vector red      = <1.0, 0.0, 0.0>;
vector green    = <0.0, 1.0, 0.0>;
vector blue     = <0.0, 0.0, 1.0>;
vector gray     = <0.502, 0.502, 0.502>;

normal_tailwag()
{
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>))); 
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  10>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*(start)));
}

AdminMenu(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list main_admin = [ "Normal", "Sleep", "Touch", "Setup", "Exit" ];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s Pussy Menu", main_admin, channel);
}

AdminMenuSetup(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list MenuSetup = [ "Show Tail", "Hide Tail", "Show Decor", "Hide Decor", "Bright", "Color", "Glow", "Texture", "Access", "Back", "Exit" ];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s Pussy Menu", MenuSetup, channel);
}

AdminMenuGlow(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list MenuSetupGlow = [ "Glow-Off", "Glow-5", "Glow-10", "Glow-20", "Glow-40", "Glow-60", "Glow-80", "Glow-100", "Back", "Exit" ];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s Pussy Menu", MenuSetupGlow, channel);
}

AdminMenuBright(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list MenuSetupBright = [ "Full-Bright", "No-Bright", "Back", "Exit"];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s Pussy Menu", MenuSetupBright, channel);
}

AdminMenuTexture(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list MenuSetupTexture = [ "Texture 1", "Texture 2", "Texture 3", "Texture 4", "Back", "Exit" ];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s Pussy Menu", MenuSetupTexture, channel);
}

AdminMenuColor(key id)
{
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list MenuSetupColor = [ "White", "Black", "Purple", "Pink", "Red", "Green", "Blue", "---", "---", "---", "Back", "Exit" ];
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    llDialog(id, (string)owner_name + "'s Pussy Menu", MenuSetupColor, channel);
}

asMenuSetup(key id)
{
    llListenRemove(listen_handle);
    channel = llRound(llFrand(99999)+10);
    listen_handle = llListen(channel, "", id, "");
    if(llGetListLength(buttons) > 12)
        llOwnerSay("Error: There is more than 12 options, please reduce the ammount");
    else
        llDialog(id, asTagScan(menu_text, id), buttons, channel);
}

asCheckSelected(string message, key id)
{
    llListenRemove(listen_handle);
    integer index = llListFindList(buttons, [message]);
    list owner_name = llParseString2List(llKey2Name(llGetOwner()), [""], []);
    string origName = llGetObjectName();
    llSetObjectName("");
    if(index != -1)
    {
        if(llToLower(announce_type) == "say"){
            llSetObjectName((string)owner_name + "'s Tail");
            llSay(0, asTagScan(llList2String(messages, index), id));
        }
        else if(llToLower(announce_type) == "shout"){
            llSetObjectName((string)owner_name + "'s Tail");
            llShout(0, asTagScan(llList2String(messages, index), id));
        }
        else{
            llSetObjectName((string)owner_name + "'s Tail");
            llWhisper(0, asTagScan(llList2String(messages, index), id));
            
        }
    }
    llSetObjectName(origName);
}

string asTagScan(string message, key user)
{
    integer ufn = llStringLength("<users_first_name>")-1;
    integer uln = llStringLength("<users_last_name>")-1;
    integer ofn = llStringLength("<owners_first_name>")-1;
    integer oln = llStringLength("<owners_last_name>")-1;
    list parse = llParseString2List(llGetDisplayName(user), [""], []);
    string user_first_name = llList2String(parse, 0);
    string user_last_name = llList2String(parse, 1);
    parse = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [" "], []);
    string owner_first_name = llList2String(parse, 0);
    string owner_last_name = llList2String(parse, 1);
    integer ind;
    integer ind2;
    integer own;
    integer own2;
    integer done = FALSE;
    do{
        @recheck;
        ind = llSubStringIndex(message, "<users_first_name>");
        ind2 = llSubStringIndex(message, "<users_last_name>");
        own = llSubStringIndex(message, "<owners_first_name>");
        own2 = llSubStringIndex(message, "<owners_last_name>");
        if(ind != -1){
            message = llDeleteSubString(message, ind, (ind+ufn));
            message = llInsertString(message, ind, user_first_name);
            jump recheck;
        }
        else if(ind2 != -1){
            message = llDeleteSubString(message, ind2, (ind2+uln));
            message = llInsertString(message, ind2, user_last_name);
            jump recheck;
        }
        else if(own != -1){
            message = llDeleteSubString(message, own, (own+ofn));
            message = llInsertString(message, own, owner_first_name);
            jump recheck;
        }
        else if(own2 != -1){
            message = llDeleteSubString(message, own2, (own2+oln));
            message = llInsertString(message, own2, owner_last_name);
            jump recheck;
        }
        else if(ind == -1 && ind2 == -1 && own == -1 && own2 == -1)
            done = TRUE;
    }
    while(done < FALSE);
    return message;
}

default
{
    state_entry()
    {
        if (public)
            llOwnerSay("Access: Public on!");
        else
            llOwnerSay("Access: Public off!");

        if (normal){
            llOwnerSay("Tail: Currently on!");
            start = (RAD_TO_DEG*llRot2Euler(llGetLocalRot()));
            llSetTimerEvent(5 + llFrand(10));
            normal = TRUE;
        }
        else{
            llOwnerSay("Tail: Currently off!");
            normal = FALSE;
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    touch_start(integer _num)
    {
        key toucher_key = llDetectedKey(0);
        list username = llParseString2List(llGetDisplayName(toucher_key), [""], []);
        if (toucher_key == llGetOwner())
            AdminMenu(toucher_key);
        else{
            if (public){
                llOwnerSay((string)username + " touched your tail.");
                asMenuSetup(toucher_key);
            }
            else
                llOwnerSay("DENIED: " + (string)username + " touched your tail.");
        }
    }
    
    listen( integer _channel, string _name, key _id, string _message) 
    {
        if (_id != llGetOwnerKey(llGetOwner()))
            asCheckSelected(_message, _id);
        else{
            if ( _message == "Exit" )
                return;
            else if (_message == "Hide Tail"){
                llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            }
            else if (_message == "Show Tail"){
                llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
            }
            else if (_message == "Touch")
                asMenuSetup(_id);
            else if (_message == "Hide Decor"){
                llSetLinkAlpha(_link_a, 0.0, ALL_SIDES);
                llSetLinkAlpha(_link_b, 0.0, ALL_SIDES);
                llSetLinkAlpha(_link_c, 0.0, ALL_SIDES);
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            }
            else if (_message == "Show Decor"){
                llSetLinkAlpha(_link_a, 1.0, ALL_SIDES);
                llSetLinkAlpha(_link_b, 1.0, ALL_SIDES);
                llSetLinkAlpha(_link_c, 1.0, ALL_SIDES);
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
            }
            else if ( _message == "Access" ){
                if (public){
                    llOwnerSay("Access: Public on!");
                }
                else{
                    llOwnerSay("Access: Public off!");
                }
                public = !public;
            }
            else if ( _message == "Normal" ){
                normal = TRUE;
                normal_tailwag();
                llOwnerSay("Tail: Awaken");
            }
            else if ( _message == "Sleep" ){
                normal  = FALSE;
                llOwnerSay("Tail: Sleeping");
            }
            else if ( _message == "Back" )
                AdminMenu(_id);
            else if ( _message == "Setup" )
                AdminMenuSetup(_id);
            else if ( _message == "Bright" )
                AdminMenuBright(_id);
            else if ( _message == "Glow" )
                AdminMenuGlow(_id);
            else if ( _message == "Texture" )
                AdminMenuTexture(_id);
            else if ( _message == "Color" )
                AdminMenuColor(_id);
            else if ( _message == "Glow-Off" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.0]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.0]);
            }
            else if ( _message == "Glow-5" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.05]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.05]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.05]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.05]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.05]);
            }
            else if ( _message == "Glow-10" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.1]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.1]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.1]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.1]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.1]);
            }
            else if ( _message == "Glow-20" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.2]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.2]);
            }
            else if ( _message == "Glow-40" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.4]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.4]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.4]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.4]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.4]);
            }
            else if ( _message == "Glow-60" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.6]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.6]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.6]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.6]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.6]);
            }
            else if ( _message == "Glow-80" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.8]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.8]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.8]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.8]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.8]);
            }
            else if ( _message == "Glow-100" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,1.0]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,1.0]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,1.0]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,1.0]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,1.0]);
            }
            else if ( _message == "Full-Bright" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
            }
            else if ( _message == "No-Bright" ){
                llSetLinkPrimitiveParamsFast(_link_a, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_b, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_c, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_d, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
                llSetLinkPrimitiveParamsFast(_link_e, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            }
            else if ( _message == "Texture 1" ){
                llSetLinkTexture(_texture_link_a, texture_a, ALL_SIDES);
                llSetLinkTexture(_texture_link_b, texture_a, ALL_SIDES);
                llSetLinkTexture(_texture_link_c, texture_a, ALL_SIDES);
            }
            else if ( _message == "Texture 2" ){
                llSetLinkTexture(_texture_link_a, texture_b, ALL_SIDES);
                llSetLinkTexture(_texture_link_b, texture_b, ALL_SIDES);
                llSetLinkTexture(_texture_link_c, texture_a, ALL_SIDES);
            }
            else if ( _message == "Texture 3" ){
                llSetLinkTexture(_texture_link_a, texture_c, ALL_SIDES);
                llSetLinkTexture(_texture_link_b, texture_c, ALL_SIDES);
                llSetLinkTexture(_texture_link_c, texture_a, ALL_SIDES);
            }
            else if ( _message == "Texture 4" ){
                llSetLinkTexture(_texture_link_a, texture_d, ALL_SIDES);
                llSetLinkTexture(_texture_link_b, texture_d, ALL_SIDES);
                llSetLinkTexture(_texture_link_c, texture_a, ALL_SIDES);
            }
            else if ( _message == "White" ){
                llSetLinkColor(_link_a, white, ALL_SIDES);
                llSetLinkColor(_link_b, white, ALL_SIDES);
                llSetLinkColor(_link_c, white, ALL_SIDES);
                llSetLinkColor(_link_d, white, ALL_SIDES);
                llSetLinkColor(_link_e, white, ALL_SIDES);
            }
            else if ( _message == "Black" ){
                llSetLinkColor(_link_a, black, ALL_SIDES);
                llSetLinkColor(_link_b, black, ALL_SIDES);
                llSetLinkColor(_link_c, black, ALL_SIDES);
                llSetLinkColor(_link_d, black, ALL_SIDES);
                llSetLinkColor(_link_e, black, ALL_SIDES);
            }
            else if ( _message == "Purple" ){
                llSetLinkColor(_link_a, purple, ALL_SIDES);
                llSetLinkColor(_link_b, purple, ALL_SIDES);
                llSetLinkColor(_link_c, purple, ALL_SIDES);
                llSetLinkColor(_link_d, purple, ALL_SIDES);
                llSetLinkColor(_link_e, purple, ALL_SIDES);
            }
            else if ( _message == "Pink" ){
                llSetLinkColor(_link_a, pink, ALL_SIDES);
                llSetLinkColor(_link_b, pink, ALL_SIDES);
                llSetLinkColor(_link_c, pink, ALL_SIDES);
                llSetLinkColor(_link_d, pink, ALL_SIDES);
                llSetLinkColor(_link_e, pink, ALL_SIDES);
            }
            else if ( _message == "Red" ){
                llSetLinkColor(_link_a, red, ALL_SIDES);
                llSetLinkColor(_link_b, red, ALL_SIDES);
                llSetLinkColor(_link_c, red, ALL_SIDES);
                llSetLinkColor(_link_d, red, ALL_SIDES);
                llSetLinkColor(_link_e, red, ALL_SIDES);
            }
            else if ( _message == "Green" ){
                llSetLinkColor(_link_a, green, ALL_SIDES);
                llSetLinkColor(_link_b, green, ALL_SIDES);
                llSetLinkColor(_link_c, green, ALL_SIDES);
                llSetLinkColor(_link_d, green, ALL_SIDES);
                llSetLinkColor(_link_e, green, ALL_SIDES);
            }
            else if ( _message == "Blue" ){
                llSetLinkColor(_link_a, blue, ALL_SIDES);
                llSetLinkColor(_link_b, blue, ALL_SIDES);
                llSetLinkColor(_link_c, blue, ALL_SIDES);
                llSetLinkColor(_link_d, blue, ALL_SIDES);
                llSetLinkColor(_link_e, blue, ALL_SIDES);
            }
        }
    }
    
    timer()
    {
        if (normal){
            normal_tailwag();
            llSetTimerEvent(5 + llFrand(10));
        }
    }
}