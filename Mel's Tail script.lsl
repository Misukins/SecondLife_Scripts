key owner;

integer listenState  = 0;
integer listenChannel;
integer listenHandle;

integer normal  = TRUE;
integer public  = TRUE;

integer _link_a = 3;
integer _link_b = 4;
integer _link_c = 5;
integer _link_d = 6;
integer _link_e = 9;

string announce_type = "whisper";
string menu_text = "<owners_first_name>'s Tail Menu\nWhat do you want to do with my tail <users_first_name>?";

string white = "65e1c058-2757-e5b6-d6e9-653a58c56a63";
string ear_white = "7f2c82b9-4bed-9a58-badd-c5b3c4b0af19";
string black = "fd0db2a7-da91-0328-c4c7-d54d3fece789";
string ear_black = "b155fd00-9a66-4d52-93ce-5827a538e7ef";
string goth = "543f06e6-b708-8f88-fa2e-4abe04736e3b";
string ear_goth = "b2a789d7-bb8e-1081-77b3-31ddb7148322";
string vampire = "98575858-03a8-0e4b-6fd0-357b8a503464";
string ear_vampire = "f0057575-505d-f7bc-747e-f21922e1f720";
string amber = "5a57b143-5b82-8cc3-1479-12613cc6f401";
string ear_amber = "fd9df09b-71d9-bc7d-c3fa-bd7cb4ace224";
string barbie = "15d20f4f-b883-8e08-decf-9840eb0b5f35";
string ear_barbie = "fd9df09b-71d9-bc7d-c3fa-bd7cb4ace224";
string blondie = "5502523a-3458-9c7e-92f5-a891098e7fe3";
string ear_blondie = "5d8a50b9-9b7f-df49-aede-d6cd180c2b65";
string caramel = "1bf94260-6fb6-087e-32d5-a7259365d656";
string ear_caramel = "8850f6ec-3ee6-e7bf-868d-884f8bcb81f4";
string purple = "2653cca1-636b-b580-963c-effa796be661";
string ear_purple = "669408b2-ca79-8c47-1e6b-01cbc3b74e6f";
string chestnut = "7a156d48-a0fa-69ad-11e4-6bf8cf18451c";
string ear_chestnut = "d3ffbf32-ff96-b52a-d642-b3cf70548a8a";
string pink = "c4369219-6129-4b78-6a65-2f20bbe797ca";
string ear_pink = "56576b21-5b1b-936a-615a-10616c4f8ed4";
string sammie = "66ddf90d-b3b9-e03b-1415-c4c07957c6ca";
string ear_sammie = "c84eeba7-24af-ad31-d360-2774a2d6295c";
string sandy = "707a6c79-3bcf-0611-5491-8316b3193580";
string ear_sandy = "06fd68e4-9aa7-8aea-ca95-673b1ddd3779";
string mandi = "22243232-24e8-2ed5-f472-4caa45a9df0d";
string ear_mandi = "07f055c4-e4c5-5b59-c75c-0374b5ef4f7d";
string cocoa = "27fcc760-6dc6-94af-2e3b-cce732e39046";
string ear_cocoa = "1685cc6f-05c2-0086-823d-80db75b8010f";
string jamie = "3949b910-db8e-c468-8ee9-71697fdd8deb";
string ear_jamie = "3dadd1a0-a396-a903-e88d-5252844fd8a3";
string madrid = "e475fdb6-26b5-f733-3d6d-f03ffdf8d5d4";
string ear_madrid = "86fa0778-819f-5717-83dd-6bcd8f2e2376";
string jenny = "9abf2b72-6b03-5e37-7664-112c814b3247";
string ear_jenny = "e732454c-e2a9-b5b6-32db-58ce7f9dfc2b";

list MenuOwn            = [ "Normal", "Sleep", "Setup", "Exit" ];
list MenuSetup          = [ "Show Tail", "Hide Tail", "Show Decor", "Hide Decor", "Bright", "Color", "Glow", "Texture", "Access", "Back", "Exit" ];
list MenuSetupGlow      = [ "Glow-Off", "Glow-5", "Glow-10", "Glow-20", "Glow-40", "Glow-60", "Glow-80", "Glow-100", "Back", "Exit" ];
list MenuSetupBright    = [ "Full-Bright", "No-Bright", "Back", "Exit"];
list MenuOwnTexture     = [ "White", "Black", "Goth", "Black/Purple", "Amber", "Barbie", "Blondie", "Caramel", "Black/Red", "More", "Back", "Exit" ];
list MenuOwnSubTexture  = [ "Sammie", "Sandy", "Pink", "Purple", "Mandi", "Cocoa", "Jamie", "Madrid", "Jenny", " ", "Back", "Exit" ];
list MenuSetupColor     = [ "White*", "Black*", "Purple*", "Pink*", "Red*", "Green*", "Blue*", "---", "---", "---", "Back", "Exit" ];
list buttons            = ["-Hug-", "-Stroke-", "-Kiss-", "-Sniff-", "-Clean-", "-Pet-", "-Bite-", "-Lick-", "-Pull-", "-Put in-", "-Grabs out-", "-Hump-" ];

list messages = [
"<users_first_name> picks up <owners_first_name>'s tail and hugs it gently.",
"<users_first_name> gently strokes their fingers through <owners_first_name>'s tail.",
"<users_first_name> picks up <owners_first_name>'s tail and kisses it.",
"<users_first_name> picks up <owners_first_name>'s tail and sniffs it a few times.",
"<users_first_name> picks up <owners_first_name>'s tail and picks out all the dirt.",
"<users_first_name> picks up and begins petting <owners_first_name>'s tail.",
"<users_first_name> picks up and bites <owners_first_name>'s tail, when nobody's looking.",
"<users_first_name> picks up and licks <owners_first_name>'s tail to get a growl out of them.",
"<users_first_name> picks up and pulls <owners_first_name>'s tail.",
"<users_first_name> picks up and puts old gum in <owners_first_name>'s tail.",
"<users_first_name> picks up and grabs old gum from <owners_first_name>'s tail.",
"<users_first_name> picks up and humps <owners_first_name>'s tail."
];

vector start;

vector decor_white    = <1.0, 1.0, 1.0>;
vector decor_black    = <0.0, 0.0, 0.0>;
vector decor_purple   = <0.5, 0.0, 0.5>;
vector decor_pink     = <1.0, 0.75, 0.8>;
vector decor_red      = <1.0, 0.0, 0.0>;
vector decor_green    = <0.0, 1.0, 0.0>;
vector decor_blue     = <0.0, 0.0, 1.0>;

normal_tailwag()
{
    /*
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(20), llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(-20), llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(20), llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(-20), llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(20), llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(-20), llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(20), llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(-20), llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(20), llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, llFrand(-20), llFrand(-10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, llFrand(10)>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*(start)));
    */
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));

    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));

    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>))); 

    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));

    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0, -20>)));

    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));
    llSetRot(llEuler2Rot(DEG_TO_RAD*((RAD_TO_DEG*llRot2Euler(llGetLocalRot()))+ <0, 0,  20>)));
    
    llSetRot(llEuler2Rot(DEG_TO_RAD*(start)));
}

asMenuSetup(key id)
{
    llListenRemove( listenHandle );
    listenChannel = llRound(llFrand(99999)+10);
    listenHandle = llListen(listenChannel, "", id, "");
    if(llGetListLength(buttons) > 12)
    {
        llOwnerSay("Error: There is more than 12 options, please reduce the ammount");
    }
    else
    {
        llDialog(id, asTagScan(menu_text, id), buttons, listenChannel);
    }
}

asCheckSelected(string message, key id)
{
    llListenRemove( listenHandle );
    integer index = llListFindList(buttons, [message]);
    list owner_name = llParseString2List(llKey2Name(llGetOwner()), [""], []);
    if(index != -1)
    {
        if(llToLower(announce_type) == "say")
        {
            string origName = llGetObjectName();
            llSetObjectName((string)owner_name + "'s Tail");
            llSay(0, asTagScan(llList2String(messages, index), id));
            llSetObjectName(origName);
        }
        else if(llToLower(announce_type) == "shout")
        {
            string origName = llGetObjectName();
            llSetObjectName((string)owner_name + "'s Tail");
            llShout(0, asTagScan(llList2String(messages, index), id));
            llSetObjectName(origName);
        }
        else
        {
            string origName = llGetObjectName();
            llSetObjectName((string)owner_name + "'s Tail");
            llWhisper(0, asTagScan(llList2String(messages, index), id));
            llSetObjectName(origName);
        }
    }
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
    do
    {
        @recheck;
        ind = llSubStringIndex(message, "<users_first_name>");
        ind2 = llSubStringIndex(message, "<users_last_name>");
        own = llSubStringIndex(message, "<owners_first_name>");
        own2 = llSubStringIndex(message, "<owners_last_name>");
        if(ind != -1)
        {
            message = llDeleteSubString(message, ind, (ind+ufn));
            message = llInsertString(message, ind, user_first_name);
            jump recheck;
        }
        else if(ind2 != -1)
        {
            message = llDeleteSubString(message, ind2, (ind2+uln));
            message = llInsertString(message, ind2, user_last_name);
            jump recheck;
        }
        else if(own != -1)
        {
            message = llDeleteSubString(message, own, (own+ofn));
            message = llInsertString(message, own, owner_first_name);
            jump recheck;
        }
        else if(own2 != -1)
        {
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
        start = (RAD_TO_DEG*llRot2Euler(llGetLocalRot()));
        llSetTimerEvent(10 + llFrand(10));
        owner = llGetOwner();
        listenChannel = llFloor(llFrand(2000000));
        if ( listenHandle )
            llListenRemove( listenHandle );
        listenHandle = llListen(listenChannel, "", owner, "");
    }
    
    run_time_permissions(integer a)
    {
        if(a & PERMISSION_ATTACH)
            llDetachFromAvatar();
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
        {
            listenState = 0;
            llListenControl(listenHandle, TRUE);
            llDialog(llGetOwner(), "\nPlease select an option:", MenuOwn, listenChannel);
        }
        else
        {
            if (public)
            {
                listenState = 0;
                llListenControl(listenHandle, TRUE);
                llOwnerSay((string)username + " touched your tail.");
                asMenuSetup(toucher_key);
            }
            else
            {
                llOwnerSay((string)username + " touched your tail.");
            }
        }
    }
    
    listen( integer _channel, string _name, key _id, string _message) 
    {
        llListenControl(listenHandle, FALSE);
        if ( _message == "Exit" )
            return;
        else if (_message == "Hide Tail")
            llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
        else if (_message == "Show Tail")
            llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
        else if (_message == "Hide Decor")
        {
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
        else if (_message == "Show Decor")
        {
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
        else if ( _message == "Normal" )
        {
            normal = TRUE;
            normal_tailwag();
            llWhisper(14743, "twitch_on");
        }
        else if ( _message == "Sleep" )
        {
            normal  = FALSE;
            llWhisper(14743, "twitch_off");
        }
        else if ( _message == "Access" )
        {
            if (!public)
            {
                public = !public;
                llOwnerSay("Access: Public on!");
            }
            else
            {
                public = !public;
                llOwnerSay("Access: Public off!");
            }
        }
        else if ( _message == "Back" )
        {
            listenState = 0;
            llListenControl(listenHandle, TRUE);
            llDialog(owner, "\nPlease select an option:", MenuOwn, listenChannel);
        }
        else if ( _message == "Setup" )
        {
            listenState = 0;
            llListenControl(listenHandle, TRUE);
            llDialog(owner, "\nPlease select an texture:", MenuSetup, listenChannel);
        }
        else if ( _message == "Texture" )
        {
            listenState = 0;
            llListenControl(listenHandle, TRUE);
            llDialog(owner, "\nPlease select an texture:", MenuOwnTexture, listenChannel);
        }
        else if ( _message == "More" )
        {
            listenState = 0;
            llListenControl(listenHandle, TRUE);
            llDialog(owner, "\nPlease select an texture:", MenuOwnSubTexture, listenChannel);
        }
        else if ( _message == "Bright" )
        {
            listenState = 0;
            llListenControl(listenHandle, TRUE);
            llDialog(owner, "\nPlease select an texture:", MenuSetupBright, listenChannel);
        }
        else if ( _message == "Glow" )
        {
            listenState = 0;
            llListenControl(listenHandle, TRUE);
            llDialog(owner, "\nPlease select an texture:", MenuSetupGlow, listenChannel);
        }
        else if ( _message == "Color" )
        {
            listenState = 0;
            llListenControl(listenHandle, TRUE);
            llDialog(owner, "\nPlease select an option:", MenuSetupColor, listenChannel);
        }
        else if ( _message == "Glow-Off" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.0]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.0]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.0]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.0]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.0]);
            llWhisper(14743, "glow_off");
        }
        else if ( _message == "Glow-5" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.05]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.05]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.05]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.05]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.05]);
            llWhisper(14743, "glow_5");
        }
        else if ( _message == "Glow-10" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.1]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.1]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.1]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.1]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.1]);
            llWhisper(14743, "glow_10");
        }
        else if ( _message == "Glow-20" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.2]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.2]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.2]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.2]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.2]);
            llWhisper(14743, "glow_20");
        }
        else if ( _message == "Glow-40" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.4]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.4]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.4]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.4]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.4]);
            llWhisper(14743, "glow_40");
        }
        else if ( _message == "Glow-60" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.6]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.6]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.6]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.6]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.6]);
            llWhisper(14743, "glow_60");
        }
        else if ( _message == "Glow-80" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,0.8]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,0.8]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,0.8]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,0.8]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,0.8]);
            llWhisper(14743, "glow_80");
        }
        else if ( _message == "Glow-100" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_GLOW,ALL_SIDES,1.0]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_GLOW,ALL_SIDES,1.0]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_GLOW,ALL_SIDES,1.0]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_GLOW,ALL_SIDES,1.0]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_GLOW,ALL_SIDES,1.0]);
            llWhisper(14743, "glow_100");
        }
        else if ( _message == "Full-Bright" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
            llWhisper(14743, "bright_on");
        }
        else if ( _message == "No-Bright" )
        {
            llSetLinkPrimitiveParamsFast(_link_a, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            llSetLinkPrimitiveParamsFast(_link_b, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            llSetLinkPrimitiveParamsFast(_link_c, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            llSetLinkPrimitiveParamsFast(_link_d, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            llSetLinkPrimitiveParamsFast(_link_e, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            llWhisper(14743, "bright_off");
        }
        else if ( _message == "White" )
        {
            llWhisper(14741, (string)white);
            llWhisper(14742, (string)ear_white);
        }
        else if ( _message == "Black" )
        {
            llWhisper(14741, (string)black);
            llWhisper(14742, (string)ear_black);
        }
        else if ( _message == "Goth" )
        {
            llWhisper(14741, (string)goth);
            llWhisper(14742, (string)ear_goth);
        }
        else if ( _message == "Black/Purple" )
        {
            llWhisper(14741, (string)vampire);
            llWhisper(14742, (string)ear_vampire);
        }
        else if ( _message == "Amber" )
        {
            llWhisper(14741, (string)amber);
            llWhisper(14742, (string)ear_amber);
        }
        else if ( _message == "Barbie" )
        {
            llWhisper(14741, (string)barbie);
            llWhisper(14742, (string)ear_barbie);
        }
        else if ( _message == "Blondie" )
        {
            llWhisper(14741, (string)blondie);
            llWhisper(14742, (string)ear_blondie);
        }
        else if ( _message == "Caramel" )
        {
            llWhisper(14741, (string)caramel);
            llWhisper(14742, (string)ear_caramel);
        }
        else if ( _message == "Purple" )
        {
            llWhisper(14741, (string)purple);
            llWhisper(14742, (string)ear_purple);
        }
        else if ( _message == "Black/Red" )
        {
            llWhisper(14741, (string)chestnut);
            llWhisper(14742, (string)ear_chestnut);
        }
        else if ( _message == "Pink" )
        {
            llWhisper(14741, (string)pink);
            llWhisper(14742, (string)ear_pink);
        }
        else if ( _message == "Sammie" )
        {
            llWhisper(14741, (string)sammie);
            llWhisper(14742, (string)ear_sammie);
        }
        else if ( _message == "Sandy" )
        {
            llWhisper(14741, (string)sandy);
            llWhisper(14742, (string)ear_sandy);
        }
        else if ( _message == "Mandi" )
        {
            llWhisper(14741, (string)mandi);
            llWhisper(14742, (string)ear_mandi);
        }
        else if ( _message == "Cocoa" )
        {
            llWhisper(14741, (string)cocoa);
            llWhisper(14742, (string)ear_cocoa);
        }
        else if ( _message == "Jamie" )
        {
            llWhisper(14741, (string)jamie);
            llWhisper(14742, (string)ear_jamie);
        }
        else if ( _message == "Madrid" )
        {
            llWhisper(14741, (string)madrid);
            llWhisper(14742, (string)ear_madrid);
        }
        else if ( _message == "Jenny" )
        {
            llWhisper(14741, (string)jenny);
            llWhisper(14742, (string)ear_jenny);
        }
        else if ( _message == "White*" )
        {
            llSetLinkColor(_link_a, decor_white, ALL_SIDES);
            llSetLinkColor(_link_b, decor_white, ALL_SIDES);
            llSetLinkColor(_link_c, decor_white, ALL_SIDES);
            llSetLinkColor(_link_d, decor_white, ALL_SIDES);
            llSetLinkColor(_link_e, decor_white, ALL_SIDES);
            llWhisper(14743, "White*");
        }
        else if ( _message == "Black*" )
        {
            llSetLinkColor(_link_a, decor_black, ALL_SIDES);
            llSetLinkColor(_link_b, decor_black, ALL_SIDES);
            llSetLinkColor(_link_c, decor_black, ALL_SIDES);
            llSetLinkColor(_link_d, decor_black, ALL_SIDES);
            llSetLinkColor(_link_e, decor_black, ALL_SIDES);
            llWhisper(14743, "Black*");
        }
        else if ( _message == "Purple*" )
        {
            llSetLinkColor(_link_a, decor_purple, ALL_SIDES);
            llSetLinkColor(_link_b, decor_purple, ALL_SIDES);
            llSetLinkColor(_link_c, decor_purple, ALL_SIDES);
            llSetLinkColor(_link_d, decor_purple, ALL_SIDES);
            llSetLinkColor(_link_e, decor_purple, ALL_SIDES);
            llWhisper(14743, "Purple*");
        }
        else if ( _message == "Pink*" )
        {
            llSetLinkColor(_link_a, decor_pink, ALL_SIDES);
            llSetLinkColor(_link_b, decor_pink, ALL_SIDES);
            llSetLinkColor(_link_c, decor_pink, ALL_SIDES);
            llSetLinkColor(_link_d, decor_pink, ALL_SIDES);
            llSetLinkColor(_link_e, decor_pink, ALL_SIDES);
            llWhisper(14743, "Pink*");
        }
        else if ( _message == "Red*" )
        {
            llSetLinkColor(_link_a, decor_red, ALL_SIDES);
            llSetLinkColor(_link_b, decor_red, ALL_SIDES);
            llSetLinkColor(_link_c, decor_red, ALL_SIDES);
            llSetLinkColor(_link_d, decor_red, ALL_SIDES);
            llSetLinkColor(_link_e, decor_red, ALL_SIDES);
            llWhisper(14743, "Red*");
        }
        else if ( _message == "Green*" )
        {
            llSetLinkColor(_link_a, decor_green, ALL_SIDES);
            llSetLinkColor(_link_b, decor_green, ALL_SIDES);
            llSetLinkColor(_link_c, decor_green, ALL_SIDES);
            llSetLinkColor(_link_d, decor_green, ALL_SIDES);
            llSetLinkColor(_link_e, decor_green, ALL_SIDES);
            llWhisper(14743, "Green*");
        }
        else if ( _message == "Blue*" )
        {
            llSetLinkColor(_link_a, decor_blue, ALL_SIDES);
            llSetLinkColor(_link_b, decor_blue, ALL_SIDES);
            llSetLinkColor(_link_c, decor_blue, ALL_SIDES);
            llSetLinkColor(_link_d, decor_blue, ALL_SIDES);
            llSetLinkColor(_link_e, decor_blue, ALL_SIDES);
            llWhisper(14743, "Blue*");
        }
    }
    
    timer()
    {
        if (normal)
        {
            normal_tailwag();
            llSetTimerEvent(10 + llFrand(10));
        }
    }
}