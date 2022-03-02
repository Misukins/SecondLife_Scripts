integer ll_channel = -8888;
//list g_lLeashPrims;
//integer g_iLoop;
integer particlesON = FALSE;
string makersName;

string Texture = "9a342cda-d62a-ae1f-fc32-a77a24a85d73";
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
/* 
FindLinkedPrims()
{
    integer linkcount = llGetNumberOfPrims();
    for (g_iLoop = 2; g_iLoop <= linkcount; g_iLoop++)
    {
        string sPrimDesc = (string)llGetObjectDetails(llGetLinkKey(g_iLoop), [OBJECT_DESC]);
        list lTemp = llParseString2List(sPrimDesc, ["~"], []);
        integer iLoop;
        for (iLoop = 0; iLoop < llGetListLength(lTemp); iLoop++){
            string sTest = llList2String(lTemp, iLoop);
            if (llGetSubString(sTest, 0, 9) == "leashpoint"){
                if (llGetSubString(sTest, 11, -1) == ""){
                    g_lLeashPrims += [sTest, (string)g_iLoop, "1"];
                }
                else{
                    g_lLeashPrims += [llGetSubString(sTest, 11, -1), (string)g_iLoop, "1"];
                }
            }
        }
    }
    if (!llGetListLength(g_lLeashPrims))
    {
        g_lLeashPrims = ["collar", LINK_THIS, "1"];
    }
} */

Particle_System()
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
    llParticleSystem(Parameters);
}

MyParticle(key myTarget)
{
    saveData();
    list details = llGetObjectDetails(myTarget, ([OBJECT_NAME, OBJECT_DESC,
                            OBJECT_POS, OBJECT_ROT, OBJECT_VELOCITY,
                            OBJECT_OWNER, OBJECT_GROUP, OBJECT_CREATOR]));
    Interpolate_Scale = FALSE;
    Start_Scale = <0.04,0.04, 0>;
    End_Scale = <0.04,0.04, 0>;
    Interpolate_Colour = FALSE;
    Start_Colour = < 1, 1, 1 >;
    End_Colour = < 1, 1, 1 >;
    Start_Alpha = 1;
    End_Alpha =1;
    Emissive = TRUE;
    Age = 1;
    Rate = 1;
    Count = 50;
    Life = 0;
    Pattern = PSYS_SRC_PATTERN_EXPLODE;
    Radius = 0;
    Begin_Angle = 0;
    End_Angle = 3.14159;
    Omega = < 0, 0, 0 >;
    Follow_Source = TRUE;
    Follow_Velocity = TRUE;
    Wind = FALSE;
    Bounce = FALSE;
    Minimum_Speed = 1;
    Maximum_Speed = 1;
    Acceleration = < 0, 0, 0 >;
    Target = TRUE;
    Target_Key = myTarget;

    Particle_System();
    llOwnerSay( "UUID: " + (string)myTarget
                    + "\nName: "          + llList2String(details, 0)
                    + "\nDescription: "  + llList2String(details, 1)
                    + "\nPosition: "      + llList2String(details, 2)
                    + "\nRotation: "       + llList2String(details, 3)
                    + "\nVelocity: "       + llList2String(details, 4)
                    + "\nOwner: "          + llList2String(details, 5)
                    + "\nGroup: "          + llList2String(details, 6)
                    + "\nCreator: "        + llList2String(details, 7));
}

/*
collision_start(integer num_detected)
    {
      key  id      = llDetectedKey(0);
      list details = llGetObjectDetails(id, ([OBJECT_NAME, OBJECT_DESC,
                            OBJECT_POS, OBJECT_ROT, OBJECT_VELOCITY,
                            OBJECT_OWNER, OBJECT_GROUP, OBJECT_CREATOR]));
      llShout(PUBLIC_CHANNEL, "UUID: " + (string)id
                    + "\nName: "          + llList2String(details, 0)
                    + "\nDescription: "  + llList2String(details, 1)
                    + "\nPosition: "      + llList2String(details, 2)
                    + "\nRotation: "       + llList2String(details, 3)
                    + "\nVelocity: "       + llList2String(details, 4)
                    + "\nOwner: "          + llList2String(details, 5)
                    + "\nGroup: "          + llList2String(details, 6)
                    + "\nCreator: "        + llList2String(details, 7));
    }
*/

stopMyParticle(key myTarget)
{
    llSetObjectDesc("");
    llParticleSystem([]);
}


saveData()
{
    list saveData;
    saveData += (string)makersName;
    llSetObjectDesc(llDumpList2String(saveData, ","));
}

default
{
    state_entry()
    {
        llListen(ll_channel, "", "", "");
    }

    listen(integer channel, string name, key id, string message) 
    {
        key MyTraget_key = llDetectedKey(0);
        makersName = llKey2Name(MyTraget_key);
        if(channel == ll_channel){
            if (message == "Leash"){
                MyParticle(id);
            }
            else if (message == "unLeash"){
                stopMyParticle(id);
            }
        }
    }

    touch_start(integer total_number)
    {
        key MyTraget_key = llGetObjectName(); //llGetObjectName(); ??? something like that..
        makersName = llKey2Name(MyTraget_key);
        if (!particlesON){
            MyParticle(MyTraget_key);
        }
        else
            stopMyParticle(MyTraget_key);
        particlesON = !particlesON;
    }
}
