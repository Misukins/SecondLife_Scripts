string texturer = "e08ab401-2945-29f7-0797-a6c67a405b5b";
integer effectFlags=0;
integer running=TRUE;
key owner;

integer colorInterpolation  = TRUE;

vector  startColor          = <1,1,1>;
vector  endColor            = <1, 1, 1>;

float   startAlpha          = 0.8;
float   endAlpha            = 0.3;

integer glowEffect          = TRUE;
integer sizeInterpolation   = TRUE;

vector  startSize           = <0.5, 0.5, 0.5>;
vector  endSize             = <0.5, 0.5, 0.5>;

integer followVelocity      = TRUE;

string  texture             = texturer;

float   particleLife        = 2.0;
float   SystemLife          = 0.0;
float   emissionRate        = 0.20;

integer partPerEmission     = 5;

float   radius              = 0.0;
float   innerAngle          = 0;
float   outerAngle          = 0;

vector  omega               = <2.0, 2.0, 0.2>;

float   minSpeed            = 0.0;
float   maxSpeed            = 0.1;

vector  acceleration        = <0.0, 0.0, -0.5>;

integer windEffect          = FALSE;
integer bounceEffect        = FALSE;
integer followSource        = TRUE;
//integer followTarget        = TRUE;
key     target              = "";

integer randomAcceleration  = TRUE;
integer randomVelocity      = TRUE;
integer particleTrails      = TRUE;
integer pattern = PSYS_SRC_PATTERN_EXPLODE ;

setParticles()
{
    target="";
    if (colorInterpolation) effectFlags = effectFlags|PSYS_PART_INTERP_COLOR_MASK;
    if (sizeInterpolation)  effectFlags = effectFlags|PSYS_PART_INTERP_SCALE_MASK;
    if (windEffect)         effectFlags = effectFlags|PSYS_PART_WIND_MASK;
    if (bounceEffect)       effectFlags = effectFlags|PSYS_PART_BOUNCE_MASK;
    if (followSource)       effectFlags = effectFlags|PSYS_PART_FOLLOW_SRC_MASK;
    if (followVelocity)     effectFlags = effectFlags|PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target!="")       effectFlags = effectFlags|PSYS_PART_TARGET_POS_MASK;
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
    on_rez(integer start)
    {
		owner = llGetOwner();    
    }
	
    state_entry()
    {
		llSetBuoyancy(0.0);
        llCollisionSound("",0.0);
        llCollisionSprite("");
		llParticleSystem([]);
		llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    }
	
    collision_start(integer detected)
    {
		integer type = llDetectedType(0);
		key person = llDetectedKey(0);
		if(type & AGENT)
		{
			if(person != owner)
			{
				llSetForce(<0,0,0>, TRUE);
				running=TRUE;
				setParticles();
				llTriggerSound("hit", 0.7); 
				llSetBuoyancy(-0.1);
				llSleep(1.0);
				running=FALSE;
				llParticleSystem([]);
				llSetStatus(STATUS_PHANTOM, TRUE);
				llDie();
			}
        }  
        else
        {
			llDie();
		} 
    }
	
    land_collision(vector pos)
    {
		llParticleSystem([]);
		llSetStatus(STATUS_PHANTOM, TRUE);
		llDie();
    }
    
    
    
}
