string sound_1 = "219c5d93-6c09-31c5-fb3f-c5fe7495c115"; //Muijan Ähkäsy
string sound_2 = "5d0432d8-58c2-764e-5080-a96594257db1"; //UT I'm Hit
string sound_3 = "f6d4dd62-c5ff-5007-b8f4-2603e3692b9c"; //Squeek
string sound_4 = "b8dcf632-ace2-1598-9cec-688a9e2403bb"; //Bleeding
string sound_5 = "ad44d652-7f13-f538-7759-c248143c2877"; //Growl
string sound_6 = "8013e8ea-8978-7b21-52b7-3826c0adb0b8"; //uWu
string sound_7 = "03f9c086-cf50-0f4c-a4d5-7c32284b85ae"; //Nuaaah

integer globalListenHandle  = -0;
integer ll_channel = 666;
integer channel;
integer listen_handle;

integer On              = TRUE;
integer ParticleOn      = TRUE;

integer sound1          = FALSE;
integer sound2          = FALSE;
integer sound3          = FALSE;
integer sound4          = FALSE;
integer sound5          = FALSE;
integer sound6          = FALSE;
integer sound7          = TRUE;

float soundvolume = 0.6;
float uwusoundvolume = 3.0;
integer wait_till_next = 5;
float sleepDelay = 5.0;

integer running=TRUE;
key owner;

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

list main_menu = [ "Sounds", "On/Off", "Particles", "Exit" ];
list sounds_menu =[ "Moan", "I'm Hit", "Squeek", "Bleeding", "Growl", "uWu", "Nyaa", "Back" ];

init() 
{
    llListenRemove(listen_handle);
    owner = llGetOwner();
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", owner, "");
}

soundsOFF()
{
    running=FALSE;
    llParticleSystem([]);
    llSetStatus(STATUS_PHANTOM, TRUE);
    llDie();
    llSetTimerEvent(0);
}

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
    Texture = "53e5859e-f122-87dc-a31a-21270e53d37a";
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

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }

    state_entry()
    {
        globalListenHandle = llListen(ll_channel, "", llGetOwner(), "");
        init();
        llOwnerSay("Type /" +  (string)ll_channel + "menu for Menu");
        if (On)
            llOwnerSay("Collision is now On..");
        else{
            llOwnerSay("Collision is now Off..");
            llParticleSystem([]);
            llSetStatus(STATUS_PHANTOM, TRUE);
            llDie();
        }
        if (ParticleOn)
            llOwnerSay("Particles are On..");
        else
            llOwnerSay("Particles are Off..");
    }
    
    listen(integer channel, string name, key id, string message) 
    {
        if (id == owner){
            if (message == "Exit")
                return;
            else if (message == "On/Off"){
                    if (On){
                    llOwnerSay("Collision is now Off..");
                    On = FALSE;
                    ParticleOn = FALSE;
                    sound1 = FALSE;
                    sound2 = FALSE;
                    sound3 = FALSE;
                    sound4 = FALSE;
                    sound5 = FALSE;
                    sound6 = FALSE;
                    sound7 = FALSE;
                }
                else{
                    llOwnerSay("Collision is now On..");
                    On = TRUE;
                    ParticleOn = FALSE;
                    sound1 = FALSE;
                    sound2 = FALSE;
                    sound3 = FALSE;
                    sound4 = FALSE;
                    sound5 = FALSE;
                    sound6 = FALSE;
                    sound7 = FALSE;
                    llDialog(owner, "\n\nSelect a an option", main_menu, channel);
                }
            }
            else if (message == "Particles"){
                if (ParticleOn){
                    llOwnerSay("Particles is now Off..");
                    ParticleOn = FALSE;
                }
                else{
                    llOwnerSay("Particles is now On..");
                    ParticleOn = TRUE;
                }
            }
            else if (message == "Sounds")
                llDialog(owner, "\n\nSelect a an option", sounds_menu, channel);
            else if (message == "menu")
                llDialog(owner, "\n\nSelect a an option", main_menu, channel);
            else if (message == "Back")
                llDialog(owner, "\n\nSelect a an option", main_menu, channel);
            else if (message == "Moan"){
                llOwnerSay("Moan sound enabled..");
                sound1 = TRUE;
                sound2 = FALSE;
                sound3 = FALSE;
                sound4 = FALSE;
                sound5 = FALSE;
                sound6 = FALSE;
                sound7 = FALSE;
            }
            else if (message == "I'm Hit"){
                llOwnerSay("I'm Hit sound enabled..");
                sound1 = FALSE;
                sound2 = TRUE;
                sound3 = FALSE;
                sound4 = FALSE;
                sound5 = FALSE;
                sound6 = FALSE;
                sound7 = FALSE;
            }
            else if (message == "Squeek"){
                llOwnerSay("Squeek sound enabled..");
                sound1 = FALSE;
                sound2 = FALSE;
                sound3 = TRUE;
                sound4 = FALSE;
                sound5 = FALSE;
                sound6 = FALSE;
                sound7 = FALSE;
            }
            else if (message == "Bleeding"){
                llOwnerSay("Bleeding sound enabled..");
                sound1 = FALSE;
                sound2 = FALSE;
                sound3 = FALSE;
                sound4 = TRUE;
                sound5 = FALSE;
                sound6 = FALSE;
                sound7 = FALSE;
            }
            else if (message == "Growl"){
                llOwnerSay("Growl sound enabled..");
                sound1 = FALSE;
                sound2 = FALSE;
                sound3 = FALSE;
                sound4 = FALSE;
                sound5 = TRUE;
                sound6 = FALSE;
                sound7 = FALSE;
            }
            else if (message == "uWu"){
                llOwnerSay("uWu sound enabled..");
                sound1 = FALSE;
                sound2 = FALSE;
                sound3 = FALSE;
                sound4 = FALSE;
                sound5 = FALSE;
                sound6 = TRUE;
                sound7 = FALSE;
            }
            else if (message == "Nyaa"){
                llOwnerSay("Nuah sound enabled..");
                sound1 = FALSE;
                sound2 = FALSE;
                sound3 = FALSE;
                sound4 = FALSE;
                sound5 = FALSE;
                sound6 = FALSE;
                sound7 = TRUE;
            }
        }
    }
    
    collision_start(integer detected)
    {
        integer type = llDetectedType(0);
        key person = llDetectedKey(0);
        string origName = llGetObjectName();
        if (type & AGENT){
            if (sound1 == TRUE){
                llPlaySound(sound_1, soundvolume);
                llSetTimerEvent(wait_till_next);
                soundsOFF();
            }
            else if (sound2 == TRUE){
                llPlaySound(sound_2, soundvolume);
                llSetTimerEvent(wait_till_next);
                soundsOFF();
            }
            else if (sound3 == TRUE){
                llPlaySound(sound_3, soundvolume);
                llSetTimerEvent(wait_till_next);
                soundsOFF();
            }
            else if (sound4 == TRUE){
                llPlaySound(sound_4, soundvolume);
                llSetTimerEvent(wait_till_next);
                soundsOFF();
            }
            else if (sound5 == TRUE){
                llPlaySound(sound_5, soundvolume);
                llSetTimerEvent(wait_till_next);
                soundsOFF();
            }
            else if (sound6 == TRUE){
                llPlaySound(sound_6, uwusoundvolume);
                llSetTimerEvent(wait_till_next);
                soundsOFF();
            }
            else if (sound7 == TRUE){
                llPlaySound(sound_7, soundvolume);
                llSetTimerEvent(wait_till_next);
                soundsOFF();
            }
            
            if(person != owner){
                if (ParticleOn == TRUE){
                    running=TRUE;
                    MyParticle(person);
                    llSleep(1.0);
                    running=FALSE;
                    llParticleSystem([]);
                    llSetStatus(STATUS_PHANTOM, TRUE);
                    llDie();
                }
                else{
                    llParticleSystem([]);
                    llSetStatus(STATUS_PHANTOM, TRUE);
                    llDie();
                }
            }
            llSetObjectName("");
            llOwnerSay("secondlife:///app/agent/" + (string)llDetectedKey(0) + "/about) Touched you!");
            llSetObjectName(origName);
        }
        else{
            llDie();
        }
    }
    
    timer()
    {
        soundsOFF();
    }
    
    state_exit()
    {
        llListenRemove(globalListenHandle);
    }
}