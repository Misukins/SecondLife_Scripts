/*
Made by Amy
You can use this script or edit it

[SUGGESTION]
Make a gesture and bind it like F7 "/666menu" :)
*/

key owner;
key Target_Key;

// DEFAULT ON you may edit
integer CollisionOn;
integer ParticleOn;
integer SoundsOn;
integer Running;

//Listen Channel
integer ll_channel      = 666;

integer globalListenHandle  = -0;
integer channel;
integer listen_handle;
integer wait_till_next  = 5;
integer Interpolate_Scale;
integer Interpolate_Colour;
integer Emissive;
integer Count;
integer Pattern;
integer Follow_Source;
integer Follow_Velocity;
integer Wind;
integer Bounce;
integer Target;

float soundvolume = 0.6;
float sleepDelay = 5.0;
float Start_Alpha;
float End_Alpha;
float Age;
float Rate;
float Life;
float Radius;
float Begin_Angle;
float End_Angle;
float Minimum_Speed;
float Maximum_Speed;

list main_menu;

string sound_6 = "f6d4dd62-c5ff-5007-b8f4-2603e3692b9c";
string sound_7 = "03f9c086-cf50-0f4c-a4d5-7c32284b85ae";
string Texture;

vector textColor;
vector Start_Scale;
vector End_Scale;
vector Start_Colour;
vector End_Colour;
vector Omega;
vector Acceleration;

integer random_chance(){
    if (llFrand(1.0) < 0.5)
        return TRUE;
    return FALSE;
}

init(){
    llListenRemove(listen_handle);
    owner = llGetOwner();
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", owner, "");
    globalListenHandle = llListen(ll_channel, "", llGetOwner(), "");
    llPreloadSound(sound_6);
    llPreloadSound(sound_7);
    llParticleSystem([]);
    llSetStatus(STATUS_PHANTOM, TRUE);
    llOwnerSay("Type /" +  (string)ll_channel + "menu for Menu");

    /* if(!CollisionOn)
        _CollisionON();
    else
        _CollisionOFF();

    if (!ParticleOn)
        _ParticlesON();
    else
        _ParticlesOFF();

    if (!SoundsOn)
        _WalkSoundON();
    else
        _WalkSoundOFF(); */
}

soundsOFF(){
    Running = FALSE;
    llParticleSystem([]);
    llSetStatus(STATUS_PHANTOM, TRUE);
    llSetTimerEvent(0);
}

Particle_System(){
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
    llParticleSystem(Parameters);
}

MyParticle(key myTarget){
    Texture = "53e5859e-f122-87dc-a31a-21270e53d37a";
    Interpolate_Scale = TRUE;
    Start_Scale = <0.04,0.04, 0>;
    End_Scale = <0.05,0.05, 0>;
    Interpolate_Colour = TRUE;
    Start_Colour = <llFrand(1.0),llFrand(1.0),llFrand(1.0)>;
    End_Colour = <llFrand(1.0),llFrand(1.0),llFrand(1.0)>;
    Start_Alpha = 1;
    End_Alpha = 0.1;
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
    Particle_System();
}

doMenu(key id){
    if((CollisionOn == TRUE) && (ParticleOn == TRUE)  && (SoundsOn == TRUE))
        main_menu = [ "■Collision", "■Particles", "■Sounds", "▼" ];
    else if((CollisionOn == TRUE) && (ParticleOn == FALSE)  && (SoundsOn == TRUE))
        main_menu = [ "■Collision", "□Particles", "■Sounds", "▼" ];
    else if((CollisionOn == FALSE) && (ParticleOn == TRUE)  && (SoundsOn == TRUE))
        main_menu = [ "□Collision", "■Particles", "■Sounds", "▼" ];
    else if((CollisionOn == FALSE) && (ParticleOn == TRUE)  && (SoundsOn == FALSE))
        main_menu = [ "□Collision", "■Particles", "□Sounds", "▼" ];
    else if((CollisionOn == TRUE) && (ParticleOn == FALSE)  && (SoundsOn == FALSE))
        main_menu = [ "■Collision", "□Particles", "□Sounds", "▼" ];
    else if((CollisionOn == FALSE) && (ParticleOn == FALSE)  && (SoundsOn == TRUE))
        main_menu = [ "□Collision", "□Particles", "■Sounds", "▼" ];
    else if((CollisionOn == TRUE) && (ParticleOn == TRUE)  && (SoundsOn == FALSE))
        main_menu = [ "■Collision", "■Particles", "□Sounds", "▼" ];
    else
        main_menu = [ "□Collision", "□Particles", "□Sounds", "▼" ];
    list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
    list name = llParseString2List(llGetDisplayName(id), [""], []);
    channel = llFloor(llFrand(2000000));
    globalListenHandle = llListen(channel, "", id, "");
    if (id == llGetOwner())
        llDialog(id, (string)owner_name + "'s TV Menu\nChoose an option! " + (string)name + "?", main_menu, channel);
}

_CollisionON(){
    llOwnerSay("Collision is now On..");
    CollisionOn = TRUE;
}

_CollisionOFF(){
    llOwnerSay("Collision is now Off..");
    CollisionOn = FALSE;
}

_ParticlesON(){
    llOwnerSay("Particles is now On..");
    ParticleOn = TRUE;
}

_ParticlesOFF(){
    llOwnerSay("Particles is now Off..");
    ParticleOn = FALSE;
}

_WalkSoundON(){
    llOwnerSay("Walk Sounds are On..");
    SoundsOn = TRUE;
}

_WalkSoundOFF(){
    llOwnerSay("Walk Sounds are Off..");
    SoundsOn = FALSE;
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if(change & (CHANGED_OWNER | CHANGED_INVENTORY))
            llResetScript();
    }

    state_entry()
    {
        init();
    }

    listen(integer channel, string name, key id, string message)
    {
        if (id == owner){
            if (message == "▼")
                return;
            else if (message == "■Collision"){
                _CollisionOFF();
                doMenu(id);
            }
            else if (message == "□Collision"){
                _CollisionON();
                doMenu(id);
            }
            else if (message == "■Particles"){
                _ParticlesOFF();
                doMenu(id);
            }
            else if (message == "□Particles"){
                _ParticlesON();
                doMenu(id);
            }
            else if (message == "■Sounds"){
                _WalkSoundOFF();
                doMenu(id);
            }
            else if (message == "□Sounds"){
                _WalkSoundON();
                doMenu(id);
            }
            else if (message == "menu")
                doMenu(id);
            else if (message == "Reset")
                llResetScript();
        }
    }

    collision_start(integer detected)
    {
        integer type = llDetectedType(0);
        key person = llDetectedKey(0);
        string origName = llGetObjectName();
        if (type & AGENT){
            if (SoundsOn == TRUE){
                if (random_chance()){
                    llPlaySound(sound_6, soundvolume);
                    llSetTimerEvent(wait_till_next);
                    soundsOFF();
                }
                else{
                    llPlaySound(sound_7, soundvolume);
                    llSetTimerEvent(wait_till_next);
                    soundsOFF();
                }
            }

            if(person != owner){
                if (ParticleOn == TRUE){
                    Running = TRUE;
                    MyParticle(person);
                    llSleep(2.0);
                    Running = FALSE;
                    llParticleSystem([]);
                    llSetStatus(STATUS_PHANTOM, TRUE);
                }
                else{
                    llParticleSystem([]);
                    llSetStatus(STATUS_PHANTOM, TRUE);
                }
            }

            if(CollisionOn){
                llSetObjectName("");
                llOwnerSay("secondlife:///app/agent/" + (string)llDetectedKey(0) + "/about Touched you!");
                llSetObjectName(origName);
            }
        }
    }

    timer()
    {
        soundsOFF();
    }
}