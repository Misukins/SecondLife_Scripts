key avatarID;
key userID;
key ownerID;
key managerID;
key manager1ID;
key manager2ID;
key manager3ID;
key manager4ID;
key manager5ID;
key manager6ID;
key blank_texture;
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
integer display_on_side = 0;
integer lowest_Tip = 5;

string url = "http://world.secondlife.com/resident/";
string profile_key_prefix = "<meta name=\"imageid\" content=\"";
string profile_img_prefix = "<img alt=\"profile image\" src=\"http://secondlife.com/app/image/";
string settings_file = "Podium Settings";
string userName;
string real_name;
string welcome_message;
string kick_message;

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
    Texture = "e26260df-9989-0fa0-a9ee-d90da7c6f60b";
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
    Target = TRUE;
    Target_Key = myTarget;
    Particle_System ();
}

/*
integer random_chance()
{
    if (llFrand(1.0) < 0.5) return TRUE;
    return FALSE;
}
*/

adminmenu(key id)
{
    if ( logged_in == 0  )
    {
        list admin_menu = [ "† Reset †", "† Exit †" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", admin_menu, channel);
    }
    else if ( logged_in == 1  )
    {
        list admin_menu = [ "† Kick †", "† Reset †", "† Exit †" ];
        llListenRemove(listener);
        channel = -1000000000 - (integer)(llFrand(1000000000));
        listener = llListen(channel, "", "", "");
        llDialog(id, "Choose an option...", admin_menu, channel);
    }
}

default
{
    state_entry()
    {
        llSetTimerEvent(300);
        llOwnerSay("Waiting to obtain Debit Permissions.");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        llSetText("Setting up...", <0.58,0,0.83>, 1.0);
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
        for (x = 0; x < llGetInventoryNumber(INVENTORY_NOTECARD); x += 1)
        {
            if (llGetInventoryName(INVENTORY_NOTECARD, x) == settings_file)
                found = TRUE; 
        }
        if (found){
            llSetText("Reading Settings file... Please wait...", <0.58,0,0.83>, 1.0);
            readKey = llGetNotecardLine(settings_file, lineCount);
        } 
        else{
            llSetText("Settings Notecard Not Found.", <0.58,0,0.83>, 1.0);
            llOwnerSay("Settings Notecard Not Found.");
        }
    }
    
    dataserver(key requested, string data)
    {
        float  floatData;
        list  listData;
        integer  integerData;
        if (requested == readKey) 
        { 
            if (data != EOF)
            {
                if ((llSubStringIndex(data, "#") != 0) && (data != "") && (data != " "))
                {
                    floatData  = (float)data;
                    integerData  = (integer)data;
                    if (count == 0)
                        managerID = data;
                    else if (count == 1)
                        manager1ID = data;
                    else if (count == 2)
                        manager2ID = data;
                    else if (count == 3)
                        manager3ID = data;
                    else if (count == 4)
                        manager4ID = data;
                    else if (count == 5)
                        manager5ID = data;
                    else if (count == 6)
                        manager6ID = data;
                    else if (count == 7)
                        blank_texture = data;
                    else if (count == 8)
                    {
                        if (floatData >= 0)
                            split = floatData;
                        else
                            split = 0.8;
                    }
                    else if (count == 9)
                        welcome_message = data;
                    else if (count == 10)
                        kick_message = data;
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
                llOwnerSay("Owner: " + (string)llKey2Name(managerID));
                llOwnerSay("Manager #1: " + (string)llKey2Name(manager1ID));
                llOwnerSay("Manager #2: " + (string)llKey2Name(manager2ID));
                llOwnerSay("Manager #3: " + (string)llKey2Name(manager3ID));
                llOwnerSay("Manager #4: " + (string)llKey2Name(manager4ID));
                llOwnerSay("Manager #5: " + (string)llKey2Name(manager5ID));
                llOwnerSay("Manager #6: " + (string)llKey2Name(manager6ID));
                llOwnerSay("Split: " + (string)split);
                llOwnerSay("Welcome: " + (string)welcome_message);
                llOwnerSay("Kick: " + (string)kick_message);
                llOwnerSay("===============");
                llOwnerSay("Ready for Service!");
                llSleep(0.5);
                state idle;
            }
        }
    }
}

state idle
{
    state_entry()
    {
        llSetClickAction(CLICK_ACTION_SIT);
        llSetTexture(blank_texture, display_on_side);
        logged_in = 0;
        totaldonated = 0;
        llParticleSystem ([]);
        llSetText("All Done!", <0.58,0,0.83>, 1.0);
        llSleep(5.0);
        llSetText("", <0.58,0,0.83>, 1.0);
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    changed(integer change)
    {
        key sittingAvatar = llAvatarOnLinkSitTarget(LINK_ROOT);
        if(sittingAvatar)
        {
            userID = sittingAvatar;
            list userName = llParseString2List(llGetDisplayName(userID), [""], []);
            real_name = llKey2Name(userID);
            llInstantMessage(userID, "Welcome " + (string)userName + " (" + (string)real_name + "), " + welcome_message);
            llMessageLinked(LINK_ROOT, 0, "signed in", userID);
            llSleep(0.5);
            state register;
        }
        if (change & CHANGED_OWNER)
            llResetScript();
    }
    
    touch_start(integer total_number)
    {
        avatarID = llDetectedKey(0);
        ownerID = llGetOwner();
        if(avatarID == ownerID)
            adminmenu(avatarID);
        else if(avatarID == managerID)
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
    }
    
    listen( integer _channel, string _name, key _id, string _message)
    {
        llListenControl(listener, FALSE);
        if (_message == "† Exit †")
            return;
        else if (_message == "† Reset †")
            llResetScript();
    }
}

state register
{
    state_entry()
    {
        profile_key_prefix_length = llStringLength(profile_key_prefix);
        profile_img_prefix_length = llStringLength(profile_img_prefix);
        llSetTexture(blank_texture, display_on_side);
        llRequestAgentData(userID, DATA_NAME);
        llSetText("Logging user in...", <0.58,0,0.83>, 1.0);
    }
    
    dataserver(key queryid, string data)
    {
        real_name = data;
        userName = llGetDisplayName(userID);
        llSleep(0.5);
        state registered;
    }
}

state registered
{
    state_entry()
    {
        logged_in = 1;
        llSetTimerEvent(5);
        llSetClickAction(CLICK_ACTION_PAY);
        llParticleSystem ([]);
        llSetText("Logged user in... Have a great party!", <0.58,0,0.83>, 1.0);
        llSleep(5.0);
        llSetText("", <0.58,0,0.83>, 1.0);
    }
    
    touch_start(integer total_number)
    {
        avatarID = llDetectedKey(0);
        ownerID = llGetOwner();
        if(avatarID == ownerID)
            adminmenu(avatarID);
        else if(avatarID == managerID)
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
    }
    
    changed(integer change)
    {
        key sittingAvatar = llAvatarOnSitTarget();
        if(userID != sittingAvatar)
        {
            userID = sittingAvatar;
            llMessageLinked(LINK_ROOT, 0, "signed out", userID);
            llSleep(0.5);
            state unregister;
        }     
    }
    
    listen( integer _channel, string _name, key _id, string _message)
    {
        if (_message == "† Exit †")
            return;
        else if (_message == "† Kick †")
        {
            userID = _id;
            key sittingAvatar = llAvatarOnLinkSitTarget(LINK_ROOT);
            list userName = llParseString2List(llGetDisplayName(userID), [""], []);
            real_name = llKey2Name(userID);
            userID = sittingAvatar;
            llInstantMessage(userID, (string)userName + " (" + (string)real_name + "), " + kick_message);
            llUnSit(sittingAvatar);
            llSleep(0.5);
            state unregister;
        }
        else if (_message == "† Reset †")
            llResetScript();
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
            profile_pic = blank_texture;
        else
        {
            profile_pic = llGetSubString(body,s1 + s1l, s1 + s1l + 35);
            if (profile_pic == (string)NULL_KEY)
                profile_pic = blank_texture;
        }
        llSetTexture(profile_pic, display_on_side);
    }
    
    money(key _id, integer amount)
    {
        if (amount >= lowest_Tip)
        {
            list name = llParseString2List(llGetDisplayName(_id), [""], []);
            float s_amount = 0.0;
            if(userID != NULL_KEY)
            {
                s_amount = (float)amount * split;
                integer s_iamount = (integer)s_amount;
                llGiveMoney(userID, s_iamount);
                llInstantMessage(userID, (string)name +" tipped " + (string)amount + "L$");
            }
            float o_amount = (float)amount -  s_amount;
            integer o_iamount = (integer)o_amount;
            MyParticle (_id);
            //if (random_chance())
            //    llSay(0, "Thank you " + (string)name + " for your rockin' tip!");
            //else
            //    llSay(0, "Thanks for the tip " + (string)name + "! I really appreciate it.");
            llGiveMoney(ownerID, o_iamount);
        }
        else
            llInstantMessage(_id, "That's not enough money. Minimum is " + (string)lowest_Tip +  "L$");
    }
    
    timer()
    {
        llHTTPRequest( url + (string)userID,[HTTP_METHOD,"GET"],"");
        llRequestAgentData(userID, DATA_ONLINE);
        llSetTimerEvent(0);
    }
}

state unregister
{
    state_entry()
    {
        llSetPayPrice(PAY_DEFAULT, [PAY_DEFAULT ,PAY_DEFAULT, PAY_DEFAULT, PAY_DEFAULT]);
        llSleep(1.0);
        llSetText("Logging user out...", <0.58,0,0.83>, 1.0);
        state unregistered;
    }

}

state unregistered
{
    state_entry()
    {
        llSleep(1.0);
        llSetText("Logged user out... Ready for new Dancer!", <0.58,0,0.83>, 1.0);
        llSleep(5.0);
        state idle;
    }
    
}