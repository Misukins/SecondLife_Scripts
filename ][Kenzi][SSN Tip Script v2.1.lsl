key avatarID;
key userID;
key ownerID;
key clubownerID;
key manager1ID;
key manager2ID;
key manager3ID;
key manager4ID;
key manager5ID;
key manager6ID;
key blank_texture;
key particle_texture;
key particle_text;
key readKey;

float split;

integer profile_key_prefix_length;
integer profile_img_prefix_length;
integer listener;
integer channel;
integer count;
integer lineCount;
integer totaldonated;
integer logged_in;
integer access;
integer display_on_side = 1;
integer display_off_side = 2;

integer display_linkedprim;

integer lowest_Tip;
integer tiptwo;
integer tipthree;
integer tipfour;

integer ParticleOn;
integer AutoRespondOn;
integer SoundsOn;
integer ToggleAllOn;
integer particleTarget;

integer DEBUG = FALSE;

list sounds = [
"69c50631-9d17-02cb-050b-42693388f4f6", 
"77a018af-098e-c037-51a6-178f05877c6f", 
"4174f859-0d3d-c517-c424-72923dc21f65"
];

string agenturl = "secondlife:///app/agent/";
string about = "/about";

string url = "http://world.secondlife.com/resident/";
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
string profile_img_prefix = "<img alt=\"profile image\" src=\"http://secondlife.com/app/image/";
string settings_file = "][Kenzi][SSN Tip Settings";
string userName;
string real_name;
string usersTitle;
string offlineTitle;
string LogoutMessage;
string LoginMessage;
string KickMessage;
string objectname;

vector textColor;
string Texture;
integer Interpolate_Scale;
vector Start_Scale;
vector End_Scale;
integer Interpolate_Colour;
vector Start_Colour;
vector End_Colour;
float Start_Alpha;
float End_Alpha;
integer Emissive;
float Age;
float Rate;
integer Count;
float Life;
integer Pattern;
float Radius;
float Begin_Angle;
float End_Angle;
vector Omega;
integer Follow_Source;
integer Follow_Velocity;
integer Wind;
integer Bounce;
float Minimum_Speed;
float Maximum_Speed;
vector Acceleration;
integer Target;
key Target_Key;

Particle_System ()
{
    list Parameters = 
    [
        PSYS_PART_FLAGS,
        (
        (Emissive * PSYS_PART_EMISSIVE_MASK) |
        (Bounce * PSYS_PART_BOUNCE_MASK) |
        (Interpolate_Colour * PSYS_PART_INTERP_COLOR_MASK) |
        (Interpolate_Scale * PSYS_PART_INTERP_SCALE_MASK) |
        (Wind * PSYS_PART_WIND_MASK) |
        (Follow_Source * PSYS_PART_FOLLOW_SRC_MASK) |
        (Follow_Velocity * PSYS_PART_FOLLOW_VELOCITY_MASK) |
        (Target * PSYS_PART_TARGET_POS_MASK)
        ),
        PSYS_PART_START_COLOR, Start_Colour,
        PSYS_PART_END_COLOR, End_Colour,
        PSYS_PART_START_ALPHA, Start_Alpha,
        PSYS_PART_END_ALPHA, End_Alpha,
        PSYS_PART_START_SCALE, Start_Scale,
        PSYS_PART_END_SCALE, End_Scale,
        PSYS_SRC_PATTERN, Pattern,
        PSYS_SRC_BURST_PART_COUNT, Count,
        PSYS_SRC_BURST_RATE, Rate,
        PSYS_PART_MAX_AGE, Age,
        PSYS_SRC_ACCEL, Acceleration,
        PSYS_SRC_BURST_RADIUS, Radius,
        PSYS_SRC_BURST_SPEED_MIN, Minimum_Speed,
        PSYS_SRC_BURST_SPEED_MAX, Maximum_Speed,
        PSYS_SRC_TARGET_KEY, Target_Key,
        PSYS_SRC_ANGLE_BEGIN, Begin_Angle,
        PSYS_SRC_ANGLE_END, End_Angle,
        PSYS_SRC_OMEGA, Omega,
        PSYS_SRC_MAX_AGE, Life,
        PSYS_SRC_TEXTURE, Texture
    ];
    llParticleSystem (Parameters);
}

MyParticle (key myTarget)
{
    Texture = particle_texture;
    Interpolate_Scale = TRUE;
    Start_Scale = <0.04,0.04, 0>;
    End_Scale = <0.5,0.5, 0>;
    Interpolate_Colour = TRUE;
    Start_Colour = < 1, 1, 1 >;
    End_Colour = < 1, 0, 0 >;
    Start_Alpha = 1;
    End_Alpha =0.1;
    Emissive = TRUE;
    Age = 4;
    Rate = 3;
    Count = 50;
    Life = 10.0;
    Pattern = PSYS_SRC_PATTERN_EXPLODE;
    Radius = 1.00;
    Begin_Angle = 0;
    End_Angle = 3.14159;
    Omega = < 0, 0, 0 >;
    Follow_Source = FALSE;
    Follow_Velocity = FALSE;
    Wind = TRUE;
    Bounce = TRUE;
    Minimum_Speed = 1;
    Maximum_Speed = 2;
    Acceleration = < 0, 0, 0 >;
    Target = particleTarget;
    Target_Key = myTarget;
    Particle_System ();
}

MakeParticles()
{
    llParticleSystem([                     
        PSYS_PART_FLAGS , 0
    | PSYS_PART_BOUNCE_MASK
    | PSYS_PART_WIND_MASK
    | PSYS_PART_INTERP_SCALE_MASK
    | PSYS_PART_FOLLOW_SRC_MASK
    | PSYS_PART_FOLLOW_VELOCITY_MASK
    ,PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE
    ,PSYS_SRC_TEXTURE,           particle_text
    ,PSYS_SRC_MAX_AGE,           10.0
    ,PSYS_PART_MAX_AGE,          4.0
    ,PSYS_SRC_BURST_RATE,        0.5
    ,PSYS_SRC_BURST_PART_COUNT,  50
    ,PSYS_SRC_BURST_RADIUS,      1.0
    ,PSYS_SRC_BURST_SPEED_MIN,   1.5
    ,PSYS_SRC_BURST_SPEED_MAX,   5.0
    ,PSYS_SRC_ACCEL,             <0.0,0.0,-0.8>
    ,PSYS_PART_START_ALPHA,      0.9
    ,PSYS_PART_END_ALPHA,        0.0
    ,PSYS_PART_START_SCALE,      <0.2,0.2,0.0>
    ,PSYS_PART_END_SCALE,        <0.01,0.01,0.0>
    ,PSYS_SRC_ANGLE_BEGIN,       PI
    ,PSYS_SRC_ANGLE_END,         PI
    ,PSYS_SRC_OMEGA,             <0.0,0.0,0.0>
            ]);
}

integer random_chance()
{
    if (llFrand(1.0) < 0.5) return TRUE;
    return FALSE;
}

integer updatetext(key _id, integer amount)
{
    list name = llParseString2List(llGetDisplayName(_id), [""], []);
    list userName = llParseString2List(llGetDisplayName(userID), [""], []);
    real_name = llKey2Name(userID);
    totaldonated += amount;
    llSetText((string)usersTitle + "\n" + (string)userName + " (" + (string)real_name + ")\nTips so far: " + (string)totaldonated + "$L\n" + (string)name + " tipped: " + (string)amount + "$L", textColor ,1);
    return 1;
}

adminmenu(key id)
{
    if ( logged_in == 0  ){
        list admin_menu = [ "♠ Sign in ♠","♠ Access ♠", "♠ Reset ♠", "♠ Exit ♠" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", admin_menu, channel);
    }
    else if ( logged_in == 1  ){
        list admin_menu = [ "♠ Sign out ♠","♠ Access ♠", "♠ Kick ♠", "♠ Reset ♠", "♠ Exit ♠" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", admin_menu, channel);
    }
}

menu(key id)
{
    if ( logged_in == 0  ){
        list main_menu = [ "♠ Sign in ♠", "♠ Exit ♠" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
    else if ( logged_in == 1  ){
        list main_menu = [ "♠ Sign out ♠", "♠ Exit ♠" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", main_menu, channel);
    }
}

access_list(key id)
{
    if (access == 0){
        if (id == ownerID)
            llInstantMessage(id, "Current access list: Public");
        else if (id == manager1ID)
            llInstantMessage(id, "Current access list: Public");
        else if (id == manager2ID)
            llInstantMessage(id, "Current access list: Public");
        else if (id == manager3ID)
            llInstantMessage(id, "Current access list: Public");
        else if (id == manager4ID)
            llInstantMessage(id, "Current access list: Public");
        else if (id == manager5ID)
            llInstantMessage(id, "Current access list: Public");
        else if (id == manager6ID)
            llInstantMessage(id, "Current access list: Public");
    }
    else if (access == 1){
        if (id == ownerID)
            llInstantMessage(id, "Current access list: Group");
        else if (id == manager1ID)
            llInstantMessage(id, "Current access list: Group");
        else if (id == manager2ID)
            llInstantMessage(id, "Current access list: Group");
        else if (id == manager3ID)
            llInstantMessage(id, "Current access list: Group");
        else if (id == manager4ID)
            llInstantMessage(id, "Current access list: Group");
        else if (id == manager5ID)
            llInstantMessage(id, "Current access list: Group");
        else if (id == manager6ID)
            llInstantMessage(id, "Current access list: Group");
    }
}

default
{
    state_entry()
    {
        llSetTimerEvent(300);
        llOwnerSay("Waiting to obtain Debit Permissions.");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        llSetText("Waiting to obtain Debit Permissions.", <1.0, 0, 0>, 1);
    }
    
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();

        if(change & INVENTORY_NOTECARD)
            llResetScript();
    }

    run_time_permissions(integer permissions)
    {
        if (permissions & PERMISSION_DEBIT)
            state loadSettings;
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }

    timer()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
    
    state_exit()
    {
        llSetTimerEvent(0);
        llOwnerSay("Initialized.");
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
        if (found)
            readKey = llGetNotecardLine(settings_file, lineCount); 
        else
            llOwnerSay("Settings Notecard Not Found.");
    }
    
    dataserver(key requested, string data)
    {
        key     keyData;
        float   floatData;
        integer integerData;
        string  stringData;
        vector  vectorData;
        if (requested == readKey){ 
            if (data != EOF){
                if ((llSubStringIndex(data, "#") != 0) && (data != "") && (data != " ")){
                    keyData     = (key)data;
                    floatData   = (float)data;
                    integerData = (integer)data;
                    stringData  = (string)data;
                    vectorData  = (vector)data;
                    if (count == 0){
                        if (keyData == NULL_KEY)
                            clubownerID = "";
                        else
                            clubownerID = keyData;
                    }
                    else if (count == 1){
                        if (keyData == NULL_KEY)
                            manager1ID = "";
                        else
                            manager1ID = keyData;
                        }
                    else if (count == 2){
                        if (keyData == NULL_KEY)
                            manager2ID = "";
                        else
                            manager2ID = keyData;
                        }
                    else if (count == 3){
                        if (keyData == NULL_KEY)
                            manager3ID = "";
                        else
                            manager3ID = keyData;
                        }
                    else if (count == 4){
                        if (keyData == NULL_KEY)
                            manager4ID = "";
                        else
                            manager4ID = keyData;
                        }
                    else if (count == 5){
                        if (keyData == NULL_KEY)
                            manager5ID = "";
                        else
                            manager5ID = keyData;
                        }
                    else if (count == 6){
                        if (keyData == NULL_KEY)
                            manager6ID = "";
                        else
                            manager6ID = keyData;
                        }
                    else if (count == 7)
                        blank_texture = stringData;
                    else if (count == 8)
                        split = floatData;
                    else if (count == 9)
                        usersTitle = stringData;
                    else if (count == 10)
                        offlineTitle = stringData;
                    else if (count == 11)
                        lowest_Tip = integerData;
                    else if (count == 12)
                        tiptwo = integerData;
                    else if (count == 13)
                        tipthree = integerData;
                    else if (count == 14)
                        tipfour = integerData;
                    else if (count == 15)
                        textColor = vectorData;
                    else if (count == 16){
                        if (stringData == "")
                            LoginMessage = "";
                        else
                            LoginMessage = stringData;
                    }
                    else if (count == 17){
                        if (stringData == "")
                            LogoutMessage = "";
                        else
                            LogoutMessage = stringData;
                    }
                    else if (count == 18){
                        if (stringData == "")
                            KickMessage = "";
                        else
                            KickMessage = stringData;
                    }
                    else if (count == 19)
                        display_linkedprim = 2;
                    else if (count == 20)
                        particle_texture = keyData;
                    else if (count == 21)
                        particle_text = keyData;
                    else if (count == 22)
                        particleTarget = integerData;
                    else if (count == 23)
                        ParticleOn = integerData;
                    else if (count == 24)
                        AutoRespondOn = integerData;
                    else if (count == 25)
                        SoundsOn = integerData;
                    else if (count == 26)
                        objectname = stringData;
                    count += 1;
                }
                lineCount += 1;
                readKey = llGetNotecardLine(settings_file, lineCount);
            }
            else{
                if (DEBUG)
                {
                    llOwnerSay("===============");
                    llOwnerSay("Settings Loaded");
                    llOwnerSay("===============");
                    llOwnerSay("Owner: " + agenturl + (string)llGetOwner() + about);
                    if (clubownerID != "")
                        llOwnerSay("ClubOwner #1: " + agenturl + (string)clubownerID + about);
                    else
                        llOwnerSay("ClubOwner #1: None");
                    if (manager1ID != "")
                        llOwnerSay("Manager #1: " + agenturl + (string)manager1ID + about);
                    else
                        llOwnerSay("Manager #1: None");
                    if (manager2ID != "")
                        llOwnerSay("Manager #2: " + agenturl + (string)manager2ID + about);
                    else
                        llOwnerSay("Manager #2: None");
                    if (manager3ID != "")
                        llOwnerSay("Manager #3: " + agenturl + (string)manager3ID + about);
                    else
                        llOwnerSay("Manager #3: None");
                    if (manager4ID != "")
                        llOwnerSay("Manager #4: " + agenturl + (string)manager4ID + about);
                    else
                        llOwnerSay("Manager #4: None");
                    if (manager5ID != "")
                        llOwnerSay("Manager #5: " + agenturl + (string)manager5ID + about);
                    else
                        llOwnerSay("Manager #5: None");
                    if (manager6ID != "")
                        llOwnerSay("Manager #6: " + agenturl + (string)manager6ID + about);
                    else 
                        llOwnerSay("Manager #6: None");
                    llOwnerSay("Offline Texture: " + (string)blank_texture);
                    llOwnerSay("Split: " + (string)split);
                    llOwnerSay("Users Title: " + (string)usersTitle);
                    llOwnerSay("Offline Title: " + (string)offlineTitle);
                    llOwnerSay("Tips: " + (string)lowest_Tip + "/" + (string)tiptwo + "/" + (string)tipthree + "/" + (string)tipfour);
                    llOwnerSay("Text Color: " + (string)textColor);
                    llOwnerSay("Login: " + (string)LoginMessage);
                    llOwnerSay("Logout: " + (string)LogoutMessage);
                    llOwnerSay("Kick: " + (string)KickMessage);
                    llOwnerSay("DisplayLink-Num: " + (string)display_linkedprim);
                    llOwnerSay("ParticleTexture: " + (string)particle_texture);
                    llOwnerSay("ParticleTexture2: " + (string)particle_text);
                    llOwnerSay("ParticleTarget: " + (string)particleTarget);
                    llOwnerSay("Particles: " + (string)ParticleOn);
                    llOwnerSay("AutoRespond: " + (string)AutoRespondOn);
                    llOwnerSay("Sounds: " + (string)SoundsOn);
                    llOwnerSay("ObjectName: " + (string)objectname);
                    llOwnerSay("===============");
                }
                llOwnerSay("Ready for Service!");
                state idle;
            }
        }
    }
}

state idle
{
    state_entry()
    {
        llSetClickAction(CLICK_ACTION_TOUCH);
        llSetText(offlineTitle, textColor, 1);
        llSetLinkTexture(display_linkedprim, blank_texture, display_on_side);
        llSetLinkTexture(display_linkedprim, blank_texture, display_off_side);
        llSetLinkTextureAnim(display_linkedprim, FALSE, 0, 1, 0, 5.0, 1, 0.25);
        llSetLinkPrimitiveParamsFast(display_linkedprim, [PRIM_FULLBRIGHT, 0, FALSE]);
        llSetLinkPrimitiveParamsFast(display_linkedprim, [PRIM_FULLBRIGHT, 1, FALSE]);
        llSetLinkPrimitiveParamsFast(display_linkedprim, [PRIM_FULLBRIGHT, 2, FALSE]);
        llSetLinkPrimitiveParamsFast(display_linkedprim, [PRIM_GLOW, 0, 0]);
        llSetLinkColor(display_linkedprim, <0, 0, 0>, 0);
        logged_in = 0;
        totaldonated = 0;
        access = 0;
        llSetPayPrice(PAY_DEFAULT, [PAY_DEFAULT ,PAY_DEFAULT, PAY_DEFAULT, PAY_DEFAULT]);
        llParticleSystem ([]);
        llTargetOmega(<0,0,0>,0.0,0.0);
        llSetLinkTextureAnim(LINK_THIS, FALSE | SMOOTH | LOOP, ALL_SIDES, 1, 0, 1.0, 1, 0.05);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW, ALL_SIDES, 0.0]);
        llSetLinkColor(LINK_THIS, <0, 0, 0>, ALL_SIDES);
        llSetObjectName(objectname);
        llSetObjectDesc("Copyright: Kenzi Achelois 2020");
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }
    
    touch_start(integer total_number)
    {
        list userName = llParseString2List(llGetDisplayName(userID), [""], []);
        list name = llParseString2List(llGetDisplayName(avatarID), [""], []);
        real_name = llKey2Name(avatarID);
        avatarID = llDetectedKey(0);
        ownerID = llGetOwner();
        integer avatarGroup = llSameGroup(avatarID);
        if(avatarID == ownerID)
            adminmenu(avatarID);
        else if(avatarID == manager1ID)
            adminmenu(avatarID);
        else if(avatarID == manager2ID)
            adminmenu(avatarID);
        else if(avatarID == manager3ID)
            adminmenu(avatarID);
        else if(avatarID == manager4ID)
            adminmenu(avatarID);
        else if(avatarID == manager5ID)
            adminmenu(avatarID);
        else if(avatarID == manager6ID)
            adminmenu(avatarID);
        else if (access == 0)
            menu(avatarID);
        else if (access == 1){
            if(avatarGroup)
                menu(avatarID);
            else if(!avatarGroup)
                llSay(0, "Sorry " + (string)name + " (" + (string)real_name + "), you are not wearing the correct group-tag.");
        }
        else
            llSay(0, "Access Denied!");
    }
    
    listen( integer _channel, string _name, key _id, string _message)
    {
        integer amount;
        llListenControl(listener, FALSE);
        if (_message == "♠ Sign in ♠"){
            userID = _id;
            list userName = llParseString2List(llGetDisplayName(userID), [""], []);
            real_name = llKey2Name(userID);
            llInstantMessage(_id, "Welcome " + (string)userName + " (" + (string)real_name + "), " + LoginMessage);
            state register;
            
        }
        else if (_message == "♠ Exit ♠")
            return;
        else if (_message == "♠ Access ♠")
        {
            if (access == 0){
                access = 1;
                access_list(_id);
            }
            else if (access == 1){
                access = 0;
                access_list(_id);
            }
        }
        else if (_message == "♠ Reset ♠")
            llResetScript();
    }
}

state register
{
    state_entry()
    {
        profile_key_prefix_length = llStringLength(profile_key_prefix);
        profile_img_prefix_length = llStringLength(profile_img_prefix);
        llSetLinkTexture(display_linkedprim, blank_texture, display_on_side);
        llSetLinkTexture(display_linkedprim, blank_texture, display_off_side);
        llRequestAgentData(userID, DATA_NAME);
        llSetText("Logging in....", textColor, 1);
    }
    
    dataserver(key queryid, string data)
    {
        real_name = data;
        userName = llGetDisplayName(userID);
        llSetObjectName(real_name + "'s TipJar");
        state registered;
    }
}

state registered
{
    state_entry()
    {
        logged_in = 1;
        llSetTimerEvent(5);
        llSetPayPrice(lowest_Tip, [lowest_Tip ,tiptwo, tipthree, tipfour]);
        llParticleSystem ([]);
        llTargetOmega(<0,0,1>,0.1,1.0);
        llSetLinkTextureAnim(display_linkedprim, ANIM_ON | SMOOTH | LOOP, 0, 1, 0, 5.0, 1, 1.55);
        llSetLinkPrimitiveParamsFast(display_linkedprim, [PRIM_FULLBRIGHT, 0, TRUE]);
        llSetLinkPrimitiveParamsFast(display_linkedprim, [PRIM_FULLBRIGHT, 1, TRUE]);
        llSetLinkPrimitiveParamsFast(display_linkedprim, [PRIM_FULLBRIGHT, 2, TRUE]);
        llSetLinkPrimitiveParamsFast(display_linkedprim, [PRIM_GLOW, 0, 0.15]);
        llSetLinkColor(display_linkedprim, <0.969, 0.608, 0.890>, 0);
        llMessageLinked(LINK_SET, 0, "signed in", "");
        llSetLinkTextureAnim(LINK_THIS, ANIM_ON | SMOOTH | LOOP, ALL_SIDES, 1, 0, 1.0, 1, 0.15);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_GLOW, ALL_SIDES, 0.15]);
        llSetLinkColor(LINK_THIS, <0.969, 0.608, 0.890>, ALL_SIDES);
    }
    
    touch_start(integer total_number)
    {
        avatarID = llDetectedKey(0);
        ownerID = llGetOwner();
        list userName = llParseString2List(llGetDisplayName(userID), [""], []);
        list name = llParseString2List(llGetDisplayName(avatarID), [""], []);
        real_name = llKey2Name(avatarID);
        integer avatarGroup = llSameGroup(avatarID);
        if(avatarID == ownerID)
            adminmenu(avatarID);
        else if(avatarID == manager1ID)
            adminmenu(avatarID);
        else if(avatarID == manager2ID)
            adminmenu(avatarID);
        else if(avatarID == manager3ID)
            adminmenu(avatarID);
        else if(avatarID == manager4ID)
            adminmenu(avatarID);
        else if(avatarID == manager5ID)
            adminmenu(avatarID);
        else if(avatarID == manager6ID)
            adminmenu(avatarID);
        else if ( logged_in == 1 & avatarID != userID ){
            llSay(0, "Sorry " + (string)name + " (" + (string)real_name + "), this is already in use.");
            return;
        }
        else if (access == 0)
            menu(avatarID);
        else if (access == 1){
            if(avatarGroup)
                menu(avatarID);
            else if(!avatarGroup)
                llSay(0, "Sorry " + (string)name + " (" + (string)real_name + "), you are not wearing the correct group-tag.");
        }
        else
            llSay(0, "Access Denied!");
    }
    
    listen( integer _channel, string _name, key _id, string _message)
    {
        if (_message == "♠ Sign out ♠"){
            userID = _id;
            list userName = llParseString2List(llGetDisplayName(userID), [""], []);
            real_name = llKey2Name(userID);
            llInstantMessage(userID, (string)userName + " (" + (string)real_name + "), " + LogoutMessage);
            llMessageLinked(LINK_SET, 0, "signed out", _id);
            llSetText("Logging out....", textColor, 1);
            llSleep(5);
            state idle;
        }
        else if (_message == "♠ Exit ♠")
            return;
        else if (_message == "♠ Access ♠"){
            if (access == 0){
                access = 1;
                access_list(userID);
            }
            else if (access == 1){
                access = 0;
                access_list(userID);
            }
        }
        else if (_message == "♠ Kick ♠"){
            list userName = llParseString2List(llGetDisplayName(userID), [""], []);
            real_name = llKey2Name(userID);
            llInstantMessage(userID, (string)userName + " (" + (string)real_name + "), " + KickMessage);
            llMessageLinked(LINK_SET, 0, "signed out", _id);
            llSetText("Logging out....", textColor, 1);
            llSleep(5);
            state idle;
        }
        else if (_message == "♠ Reset ♠")
            llResetScript();
    }

    dataserver(key queryid, string data)
    {
        integer amount;
        updatetext(queryid, amount);
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
            profile_pic = blank_texture;
        else{
            profile_pic = llGetSubString(body,s1 + s1l, s1 + s1l + 35);
            if (profile_pic == (string)NULL_KEY)
                profile_pic = blank_texture;
        }
        llSetLinkTexture(display_linkedprim, profile_pic, display_on_side);
        llSetLinkTexture(display_linkedprim, profile_pic, display_off_side);
    }
    
    money(key _id, integer amount)
    {
        if (amount >= lowest_Tip){
            float s_amount = 0.0;
            string origName = llGetObjectName();
            if(userID != NULL_KEY){
                s_amount = (float)amount * split;
                integer s_iamount = (integer)s_amount;
                llGiveMoney(userID, s_iamount);
                llSetObjectName("");
                llInstantMessage(userID, "secondlife:///app/agent/" + (string)_id + "/about tipped " + (string)amount + "L$");
                llSetObjectName(origName);
            }
            float o_amount = (float)amount -  s_amount;
            integer o_iamount = (integer)o_amount;
            list name = llParseString2List(llGetDisplayName(_id), [""], []);
            updatetext(_id, amount);
            if (ParticleOn){
                MakeParticles();
                MyParticle(_id);
            }
            if (AutoRespondOn){
                if (random_chance())
                    llSay(0, "Thank you " + (string)name + ", Sexy Spade Nation appreciates your support!!! <3");
                else
                    llSay(0, "Thank you " + (string)name + ", Sexy Spade Nation appreciates your support!");
            }
            if (SoundsOn)
                llPlaySound(llList2String(llListRandomize(sounds,1),0),0.7);

            llGiveMoney(clubownerID, o_iamount);
            llSetObjectName("");
            llInstantMessage(clubownerID, "secondlife:///app/agent/" + (string)_id + "/about just Tipped secondlife:///app/agent/" + (string)userID + "/about " + (string)amount + "L$ your cut will be " + (string)o_iamount + "L$");
            llSetObjectName(origName);
        }
        else
            llInstantMessage(_id, "That's not enough money. Minimum is " + (string)lowest_Tip +  "L$\nIf you wish to tip less please send it directly to me ;)");
    }
    
    timer()
    {
        llHTTPRequest(url + (string)userID,[HTTP_METHOD,"GET"],"");
        llRequestAgentData(userID, DATA_ONLINE);
        llSetTimerEvent(0);
    }
}