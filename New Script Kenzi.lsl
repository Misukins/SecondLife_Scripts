integer globalListenHandle  = -0;
integer ll_channel = -8888;
integer channel;
integer listen_handle;

integer ParticleOn = TRUE;
string texturer = "419c3949-3f56-6115-5f1c-1f3aa85a4606";
integer effectFlags = 0;
integer running = TRUE;
key owner;
key id;

integer colorInterpolation  = TRUE;

vector  startColor          = <1, 1, 1>;
vector  endColor            = <1, 1, 1>;

float   startAlpha          = 0.8;
float   endAlpha            = 0.3;

integer glowEffect          = TRUE;
integer sizeInterpolation   = FALSE;

vector  startSize           = <0.05, 0.05, 0.05>;
vector  endSize             = <0.01, 0.01, 0.01>;

integer followVelocity      = FALSE;

string  texture             = texturer;

float   particleLife        = 1.5;
float   SystemLife          = 0.0;
float   emissionRate        = 5.0;

integer partPerEmission     = 5;

float   radius              = 0.5;
float   innerAngle          = 0;
float   outerAngle          = 0;

vector  omega               = <0, 0, 1>;

float   minSpeed            = 1.05;
float   maxSpeed            = 1.1;

vector  acceleration        = <1.05, 1.05, 1.05>;

integer windEffect          = TRUE;
integer bounceEffect        = TRUE;
integer followSource        = TRUE;

integer randomAcceleration  = TRUE;
integer randomVelocity      = FALSE;
integer particleTrails      = TRUE;
integer pattern = PSYS_SRC_PATTERN_EXPLODE;

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
            if(DEBUG)
                debug(sTest);
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
        if(DEBUG)
            llOwnerSay("DEBUG: collar !llGetListLength (if we did not find any leashpoint... we unset the root as one)");
    }
}

setParticlesOFF()
{
    running = FALSE;
    llParticleSystem([]);
}

setParticlesON()
{
    key target = llDetectedKey(0);
    if (colorInterpolation) effectFlags = effectFlags|PSYS_PART_INTERP_COLOR_MASK;
    if (sizeInterpolation)  effectFlags = effectFlags|PSYS_PART_INTERP_SCALE_MASK;
    if (windEffect)         effectFlags = effectFlags|PSYS_PART_WIND_MASK;
    if (bounceEffect)       effectFlags = effectFlags|PSYS_PART_BOUNCE_MASK;
    if (followSource)       effectFlags = effectFlags|PSYS_PART_FOLLOW_SRC_MASK;
    if (followVelocity)     effectFlags = effectFlags|PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target!="")         effectFlags = effectFlags|PSYS_PART_TARGET_POS_MASK;
    if (glowEffect)         effectFlags = effectFlags|PSYS_PART_EMISSIVE_MASK;
    llParticleSystem([
        PSYS_PART_FLAGS,            effectFlags,
        PSYS_SRC_PATTERN,           pattern,
        PSYS_PART_START_COLOR,      startColor,
        PSYS_PART_END_COLOR,        endColor,
        PSYS_PART_START_ALPHA,      startAlpha,
        PSYS_PART_END_ALPHA,        endAlpha,
        PSYS_PART_START_SCALE,      startSize,
        PSYS_PART_END_SCALE,        endSize,    
        PSYS_PART_MAX_AGE,          particleLife,
        PSYS_SRC_ACCEL,             acceleration,
        PSYS_SRC_TEXTURE,           texture,
        PSYS_SRC_BURST_RATE,        emissionRate,
        PSYS_SRC_INNERANGLE,        innerAngle,
        PSYS_SRC_OUTERANGLE,        outerAngle,
        PSYS_SRC_BURST_PART_COUNT,  partPerEmission,      
        PSYS_SRC_BURST_RADIUS,      radius,
        PSYS_SRC_BURST_SPEED_MIN,   minSpeed,
        PSYS_SRC_BURST_SPEED_MAX,   maxSpeed, 
        PSYS_SRC_MAX_AGE,           SystemLife,
        PSYS_SRC_TARGET_KEY,        target,
        PSYS_SRC_OMEGA,             omega   ]);
}

default
{
    state_entry()
    {
        llListen(ll_channel, "", "", "");
    }

    listen(integer channel, string name, key id, string message) 
    {
        if(channel == ll_channel){
            if (message == "Leash")
            {
                llParticleSystem([]);
                ParticleOn = TRUE;
                running=TRUE;
                llWhisper(0, "TEST :: HEARD1");
                setParticlesON();
            }
            else if (message == "unLeash")
            {
                ParticleOn = FALSE;
                running=FALSE;
                llWhisper(0, "TEST :: HEARD2");
                setParticlesOFF();
            }
        }
    }
}
