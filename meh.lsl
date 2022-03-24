key Target_Key;

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
integer Running;

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

string Texture;

vector textColor;
vector Start_Scale;
vector End_Scale;
vector Start_Colour;
vector End_Colour;
vector Omega;
vector Acceleration;

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
    Texture = "e26260df-9989-0fa0-a9ee-d90da7c6f60b";
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
    Rate = 0.5;
    Count = 50;
    Life = 10.0;
    Pattern = PSYS_SRC_PATTERN_EXPLODE;
    Radius = 1.00;
    Begin_Angle = 0;
    End_Angle = 3.14159;
    Omega = < 0, 0, 0 >;
    Follow_Source = FALSE;
    Follow_Velocity = FALSE;
    Wind = FALSE;
    Bounce = TRUE;
    Minimum_Speed = 1;
    Maximum_Speed = 2;
    Acceleration = < 0, 0, 0 >;
    Target = TRUE;
    Target_Key = myTarget;
    Particle_System();
}

StopMyParticle()
{
    Running = FALSE;
    llParticleSystem([]);
}

default
{
    state_entry()
    {
        StopMyParticle();
    }
    
    attach(key agent)
    {
        list owner_name = llParseString2List(llGetDisplayName(llGetOwnerKey(llGetKey())), [""], []);
        if (agent){
            Running = TRUE;
            llOwnerSay("I love you " + (string)owner_name + " for ever! *kisses & hugs*");
            llSetTimerEvent(20);
        }
    }
    
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
        if (change & CHANGED_TELEPORT){
            Running = TRUE;
            MyParticle(llGetOwner());
            llSetTimerEvent(20);
        }
    }

    timer()
    {
        StopMyParticle();
    }
}
