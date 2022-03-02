StartSteam()
{
    integer glow = FALSE;
    integer bounce = FALSE;
    integer interpColor = FALSE;
    integer interpSize = FALSE;
    integer wind = TRUE;
    integer followSource = TRUE;
    integer followVel = TRUE;
    integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY;
    key target = llGetOwner();
    float age = 5;
    float maxSpeed = 0.05;
    float minSpeed = 0.05;
    float startAlpha = 0.8;
    float endAlpha = 0.8;
    vector startColor = <0.75,0.85,1>;
    vector endColor = <0.75,0.85,1>;
    vector startSize = <0.05,0.05,0.05>;
    vector endSize = <0.05,0.05,0.05>;
    vector push = <0.05,0.0,0.0>;
    float rate = .025;
    float radius = 0.75;
    integer count = 4;
    float outerAngle = 3*PI;
    float innerAngle = 0.5;
    vector omega = <0,0,0>;
    float life = 0;
    integer flags; 

    string texture = "af5fa42f-fc17-ed1d-4e4e-8ed520a770c5"; //Chain

    flags = 0;
    
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,rate,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
                        PSYS_SRC_TARGET_KEY,target,
                        PSYS_SRC_INNERANGLE,innerAngle, 
                        PSYS_SRC_OUTERANGLE,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
    ]);
      
}

StartSpray ()
{
    //  
}

StopSpray()
{
    llParticleSystem([]);   
}

default
{
     changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();
    }
    
    
    state_entry()
    {
         StartSteam();
         // llOwnerSay(llGetKey());
    }

    listen(integer channel, string name, key id, string message)
    {
 
         if (0 == llSubStringIndex(message, "chain on")){
            StartSteam();
        }
        else if (0 == llSubStringIndex(message, "chain off")){
            StopSpray();
        }
    }
}



